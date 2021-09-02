extends KinematicBody2D

#This camera uses "move_and_slide" to move
#Used as a bird eye view at intro

export(float) var camera_speed = 500
var target :Node2D
var min_dist = 10.0 #minimum distance the camera can approach player

var direction = Vector2()
var start_position = Vector2()


func _ready() -> void:
	#start-up configurations
	get_parent().get_node("CanvasLayer/Interface").visible = false
	get_tree().paused = true
	global_position = get_parent().get_node("Goal").global_position #initial position of intro camera
	target = get_parent().get_node_or_null("Player")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		start() #Ship the intro
	if target != null: #if target exists
		if global_position.distance_to(target.global_position) >= min_dist:
			direction = global_position.direction_to(target.global_position)
			move_and_slide(direction * camera_speed)
		else:
			start() #start the game

func start():
	get_parent().get_node("CanvasLayer/Interface").visible = true
	get_tree().paused = false
	get_node("Camera2D").current = false
	get_parent().get_node("camera/Camera2D").current = true
	queue_free()

