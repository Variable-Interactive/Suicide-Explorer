extends Control

export var next_level = "Level 2"

func _ready() -> void:
	$Won.visible = false

func _on_Finished_area_entered(area :Area2D):
	if area.is_in_group("player"):
		won()

func won():
	if next_level == "Menu":
		$Won/VBoxContainer/Next.visible = false
		$Won/ColorRect/A.emitting = true
		$Won/ColorRect/A2.emitting = true
	$Won/AudioStreamPlayer.play()
	get_tree().paused = true
	$Won.visible = true


func _on_MainMenu_pressed():
	var _err = get_tree().change_scene("res://Levels/Menu.tscn")


func _on_Next_pressed():
	var _err = get_tree().change_scene(str("res://Levels/",next_level,".tscn"))


func _on_Retry_pressed():
	var _err = get_tree().reload_current_scene()

func Saved():
	$Saved/AnimationPlayer.play("saved")
