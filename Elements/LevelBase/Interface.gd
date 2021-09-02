extends Control

export var next_level = "Level 2" #Name of next level

func _ready() -> void:
	#start-up configurations
	$Won.visible = false


func _on_Goal_area_entered(area :Area2D) -> void:
	if area.is_in_group("player"): #if player entered the goal
		won()


func won():
	if next_level == "Menu": #Special protocol if this was the last level
		$Won/VBoxContainer/Next.visible = false
		$Won/ColorRect/A.emitting = true
		$Won/ColorRect/A2.emitting = true
	$Won/AudioStreamPlayer.play()
	get_tree().paused = true
	$Won.visible = true


func Saved():
	# an indication for saved position (used in "Camera2D.gd")
	$Saved/AnimationPlayer.play("saved")


#Signals for buttons
func _on_MainMenu_pressed():
	var _err = get_tree().change_scene("res://Levels/Menu.tscn")


func _on_Next_pressed():
	var _err = get_tree().change_scene(str("res://Levels/",next_level,".tscn"))


func _on_Retry_pressed():
	var _err = get_tree().reload_current_scene()


