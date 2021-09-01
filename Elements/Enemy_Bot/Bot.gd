extends KinematicBody2D


var target :Node2D = null
var active = false
export(float) var active_range = 500
export(float) var speed = 300
var searching = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if searching:
		var result = search(target)
	
	if target != null:
		if active:
			if $Timer.is_stopped():
				$Timer.start()
			chase(target)


func chase(target_object :Node2D):
	if global_position.distance_to(target_object.global_position) >= 100:
#		look_at(target.global_position)
		var direction = global_position.direction_to(target_object.global_position)
		move_and_slide(direction * speed)

func search(target_object :Node2D):
	var result :Dictionary
	if target_object != null:
		var space_state = get_world_2d().direct_space_state
		result = space_state.intersect_ray(global_position, target_object.global_position, [self], collision_mask)
	if result:
		if not active: #If it's not active...
			if result.collider.is_in_group("player"): #...and it has found player
				active = true #then activate it
				$AnimationPlayer.play("activate")
				$AudioStreamPlayer2D.play()
		else:
			return result


func _on_Area2D_area_entered(area :Area2D):
	if area.is_in_group("player"): #Player is within the search zone
		searching = true
		target = area.get_parent()


func _on_Area2D_area_exited(area):
	if area.is_in_group("player"):
		if active:
			$AnimationPlayer.play("deactivate")
			$Timer.stop()
			active = false
			searching = false
			target = null


func _on_Timer_timeout():
	var info = search(target)
	if info:
		if info.collider.is_in_group("player"):
			var new_bullet = preload("res://Elements/Bullet/Bullet.tscn").instance()
			new_bullet.global_position = global_position
			new_bullet.global_rotation = get_angle_to(target.global_position)
			get_tree().current_scene.add_child(new_bullet)
