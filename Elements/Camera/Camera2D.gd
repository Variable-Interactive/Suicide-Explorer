extends Node2D
#This Camera will follow the player arround and also hold it's position data

onready var follow_tween = $Tween #Tween for smooth follow

var target :Node2D #Variable for target meant to to be set later
var direction = Vector2() #Direction to the target

#The Array below will store the player positions at equal intervals
var start_position: PoolVector2Array = [] 


func _ready() -> void:
	#start-up configurations
	target = get_parent().get_node_or_null("Player")
	if target != null: #If target exists in scene
		start_position.append(target.global_position) #Save it's first start posisition


func _process(_delta: float) -> void:
	#This camera will use "Tween" for movement
	if target != null:
		if !follow_tween.is_active():
			follow_tween.interpolate_property(self,"global_position",self.global_position,target.global_position,0.1)
			follow_tween.start()
	else:
		#This is cooldown for respawning if player dies
		if get_node("restart").is_stopped():
			get_node("restart").start()


func _on_restart_timeout():
	#This code Respawn the player and set it at previous save position
	target = preload("res://Elements/Player/Player.tscn").instance()
	target.global_position = start_position[start_position.size() - 1]
	if start_position.size() != 1:
		start_position.remove(start_position.size() - 1)
	get_tree().current_scene.add_child(target)
	
	#Fadeout the Gameover message
	get_parent().get_node("CanvasLayer/Interface/Label/AnimationPlayer").play("reset")
	#play the exclamation sound
	$AudioStreamPlayer.play()


func _on_SaveTimer_timeout():
	#Code responsible for saving player position
	if target != null:
		start_position.append(target.global_position)
		get_parent().get_node("CanvasLayer/Interface").Saved()
