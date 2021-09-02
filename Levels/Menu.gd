extends Control

#These are the sounds that will be played in menu
var sounds = [preload("res://Assets/Audio/Select_01.wav"), preload("res://Assets/Audio/Click_04.wav")]
#And these are the values for smooth background movement
var random_direction := Vector2.ONE
var scroll_speed = 5
onready var tween := $Tween

func _ready() -> void:
	#This code controls the red arrows appearing in front of instructions...
	#...if Menu is opened the first time only
	if Global.first_time:
		Global.first_time = false
		$ColorRect/VBoxContainer/Instructions/TextureRect.visible = true
	
	#Signal connections for menu buttons
	var _err = $ColorRect/VBoxContainer/Play.connect("pressed",self,"_on_Play_pressed")
	var _err_a = $ColorRect/VBoxContainer/Play.connect("mouse_entered",self,"_on_menu_buttons_mouse_entered")
	var _err_b = $ColorRect/VBoxContainer/Instructions.connect("pressed",self,"_on_Instructions_pressed")
	var _err_c = $ColorRect/VBoxContainer/Instructions.connect("mouse_entered",self,"_on_menu_buttons_mouse_entered")
	var _err_d = $ColorRect/VBoxContainer/Quit.connect("pressed",self,"_on_Quit_pressed")
	var _err_e = $ColorRect/VBoxContainer/Quit.connect("mouse_entered",self,"_on_menu_buttons_mouse_entered")
	var _err_f = $ColorRect/YoutubeButton.connect("pressed",self, "_on_YoutubeButton_pressed")


func _process(_delta: float) -> void:
	#This code controls Random Movement of Background
	var back_texture :AtlasTexture = $ColorRect/ColorRect/Background.texture
	back_texture.region.position += random_direction * scroll_speed
	if not tween.is_active():
		#Tweening for smooth transitioning to the new random direction
		var value_a = random_direction
		var value_b = random_direction.rotated(deg2rad(randomize_direction()))
		tween.interpolate_property(self,"random_direction",value_a,value_b,1,Tween.TRANS_BOUNCE)
		tween.start()


func randomize_direction(): #Gives the new angle for random direction
	randomize()
	var theta = rand_range(0,361)
	return theta


#Signal for Play button
func _on_Play_pressed():
	$AnimationPlayer.play("play")
	move_child($FadeOut, 1)
	$AudioStreamPlayer.stream = sounds[1]
	$AudioStreamPlayer.play()


#Signal for Instructions button
func _on_Instructions_pressed():
	$ColorRect/AcceptDialog.popup_centered()
	$AudioStreamPlayer.stream = sounds[1]
	$AudioStreamPlayer.play()


#Signal for Quit button
func _on_Quit_pressed():
	$AudioStreamPlayer.stream = sounds[1]
	$AudioStreamPlayer.play()
	get_tree().quit()


#Signal for when mouse hovers a menu button
func _on_menu_buttons_mouse_entered():
	#Play a sound
	$AudioStreamPlayer.stream = sounds[0]
	$AudioStreamPlayer.play()

#A Signal connected in editor (not through code)
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "play":
		var _err = get_tree().change_scene("res://Levels/Level 1.tscn")


#A signal for my youtube channel 
func _on_YoutubeButton_pressed():
	# LIKE AND SUBSCRIBE :)
	var _err = OS.shell_open("https://www.youtube.com/channel/UCkc4E2bJkQ91kejNKKd_U2g")
