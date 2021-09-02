extends KinematicBody2D


var target :Node2D = null #target of assasination
export(float) var active_range = 500 #range of bot
export(float) var speed = 300 #speed of bot
onready var bullet_timer = $BulletTimer

var status = { #Status of bot
	"active" : false,
	"searching" : false
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#automatically set target to "Player"
	target = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if status.searching:
		var _result = search(target)
	
	if target != null: #if the target exists in scene
		if status.active: #and the bot is activated
			if bullet_timer.is_stopped(): #then start the timer
				bullet_timer.start()
			
			chase(target) #And chase target


func chase(target_object :Node2D):
	if global_position.distance_to(target_object.global_position) >= 100:
#		look_at(target.global_position)  #Un-comment it if you want the bot to look at the player
		var direction = global_position.direction_to(target_object.global_position)
		move_and_slide(direction * speed)


func search(target_object :Node2D):
	var result :Dictionary
	if target_object != null:
		var space_state = get_world_2d().direct_space_state
		result = space_state.intersect_ray(global_position, target_object.global_position, [self], collision_mask)
	if result:
		if result.collider.is_in_group("player"): #The bot has found player
			if not status.active: #If it's not active...
				status.active = true #then activate it
				$AnimationPlayer.play("activate")
				$AudioStreamPlayer2D.play()
			return true
		else:
			return false
	else:
		return false


func _on_Radar_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"): #Player is within the search zone
		status.searching = true
		target = area.get_parent()


func _on_Radar_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"): #Player escaped the search zone
		if status.active: #If bot is active...
			$AnimationPlayer.play("deactivate") #Then deactivate it
			bullet_timer.stop()
			status.active = false
			status.searching = false
			target = null


func _on_BulletTimer_timeout() -> void:
	var in_sight = search(target) #Check if target is in sight
	if in_sight:
		var new_bullet = preload("res://Elements/Bullet/Bullet.tscn").instance()
		new_bullet.global_position = global_position
		new_bullet.global_rotation = get_angle_to(target.global_position)
		get_tree().current_scene.add_child(new_bullet)
