extends Control

var sounds = [preload("res://Assets/Audio/Select_01.wav"), preload("res://Assets/Audio/Click_04.wav")]
var random_direction := Vector2.ONE
var scroll_speed = 5
onready var tween := $Tween

func _ready() -> void:
	if Global.first_time:
		Global.first_time = false
		$ColorRect/VBoxContainer/Instructions/TextureRect.visible = true

func _process(_delta: float) -> void:
	var back_texture :AtlasTexture = $ColorRect/ColorRect/Background.texture
	back_texture.region.position += random_direction * scroll_speed
	
	if not tween.is_active():
		var value_a = random_direction
		var value_b = random_direction.rotated(deg2rad(randomize_direction()))
		tween.interpolate_property(self,"random_direction",value_a,value_b,1,Tween.TRANS_BOUNCE)
		tween.start()


func randomize_direction():
	randomize()
	var theta = rand_range(0,361)
	return theta

func _on_Quit_pressed():
	$AudioStreamPlayer.stream = sounds[1]
	$AudioStreamPlayer.play()
	get_tree().quit()


func _on_Play_pressed():
	$AnimationPlayer.play("play")
	move_child($FadeOut, 1)
	$AudioStreamPlayer.stream = sounds[1]
	$AudioStreamPlayer.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "play":
		var _err = get_tree().change_scene("res://Levels/Level 1.tscn")


func _on_Instructions_pressed():
	$ColorRect/AcceptDialog.popup_centered()
	$AudioStreamPlayer.stream = sounds[1]
	$AudioStreamPlayer.play()


func _on_Play_mouse_entered():
	$AudioStreamPlayer.stream = sounds[0]
	$AudioStreamPlayer.play()


func _on_Instructions_mouse_entered():
	$AudioStreamPlayer.stream = sounds[0]
	$AudioStreamPlayer.play()


func _on_Quit_mouse_entered():
	$AudioStreamPlayer.stream = sounds[0]
	$AudioStreamPlayer.play()


func _on_TextureButton_pressed():
	var _err = OS.shell_open("https://www.youtube.com/channel/UCkc4E2bJkQ91kejNKKd_U2g")
