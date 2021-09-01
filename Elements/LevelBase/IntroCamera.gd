extends KinematicBody2D


export(float) var camera_speed = 500
var target :Node2D

var direction = Vector2()
var start_position = Vector2()


func _ready() -> void:
	get_parent().get_node("CanvasLayer/Interface").visible = false
	get_tree().paused = true
	target = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		skip()
	if target != null:
		if global_position.distance_to(target.global_position) >= 10:
			direction = global_position.direction_to(target.global_position)
			move_and_slide(direction * camera_speed)
		else:
			skip()

func skip():
	get_parent().get_node("CanvasLayer/Interface").visible = true
	get_tree().paused = false
	get_node("Camera2D").current = false
	get_parent().get_node("camera/Camera2D").current = true
	queue_free()

