extends Node2D


func _ready() -> void:
	for effects in get_children():
		var particle :CPUParticles2D = effects
		particle.emitting = true
	yield(get_tree().create_timer(5.0), "timeout")
	queue_free()
