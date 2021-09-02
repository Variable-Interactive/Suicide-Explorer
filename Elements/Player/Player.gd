extends KinematicBody2D

#Necessary Variables
export(float) var speed := 100.0
export(float) var life := 1.0
var explode_effect = preload("res://Elements/Player/explode.tscn")

var direction := Vector2.ZERO #direction to move towards

func _ready() -> void:
	get_parent().get_node("camera").target = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("up"):
		direction.y = -1
	elif Input.is_action_pressed("down"):
		direction.y = 1
	else:
		direction.y = 0 #no up-down is pressed
	
	if Input.is_action_pressed("left"):
		direction.x = -1
		$AnimationPlayer.play("left") #animation for left
	elif Input.is_action_pressed("right"):
		direction.x = 1
		$AnimationPlayer.play("right") #animation for right
	else:
		direction.x = 0 #no left-right is pressed
		$AnimationPlayer.stop()
	
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(life) #Destroy yourself
	
	direction = direction.normalized() #normalize direction first
	
	move_and_slide(direction * speed, Vector2.UP)


func take_damage(value):
	life -= value
	if life <= 0:
		#Explode effect
		var new_explode = explode_effect.instance()
		new_explode.global_position = global_position
		get_tree().current_scene.add_child(new_explode)
		explode(3)
		
		get_parent().get_node("camera").target = null
		get_parent().get_node("CanvasLayer/Interface/Label/AnimationPlayer").play("wasted")
		queue_free()


func explode(blast_radius):
	var grid_position = position_to_tilemap(global_position, 32)
	for x in range(grid_position.x - blast_radius, grid_position.x + blast_radius, 1):
		for y in range(grid_position.y - blast_radius, grid_position.y + blast_radius, 1):
			get_parent().get_node("TileMap").set_cell(x, y, -1)


func position_to_tilemap(coordinates :Vector2, cel_size :int):
	return coordinates/cel_size
