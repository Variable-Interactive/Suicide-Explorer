extends KinematicBody2D


export(float) var camera_speed = 500
export(NodePath) var target_path
var target :Node2D

var direction = Vector2()
var start_position: PoolVector2Array = []


func _ready() -> void:
	target = get_node(target_path)
	if target != null:
		start_position.append(target.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target != null:
		if global_position.distance_to(target.global_position) >= 10:
			direction = global_position.direction_to(target.global_position)
			move_and_slide(direction * camera_speed)
		else:
			camera_speed = 500
	
	else:
		camera_speed = 3000
		if get_node("restart").is_stopped():
			get_node("restart").start()


func _on_restart_timeout():
	target = preload("res://Elements/Player/Player.tscn").instance()
	target.global_position = start_position[start_position.size() - 1]
	if start_position.size() != 1:
		start_position.remove(start_position.size() - 1)
	get_tree().current_scene.add_child(target)
	get_parent().get_node("CanvasLayer/Interface/Label/AnimationPlayer").play("reset")
	$AudioStreamPlayer.play()


func _on_SaveTimer_timeout():
	if target != null:
		start_position.append(target.global_position)
		get_parent().get_node("CanvasLayer/Interface").Saved()
