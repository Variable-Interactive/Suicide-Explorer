extends RigidBody2D


export(float) var bullet_force = 1000
export(float) var damage = 10


func _ready() -> void:
	apply_impulse(Vector2.ZERO, transform.x * bullet_force)


func _process(delta: float) -> void:
	if not is_equal_approx(0, angular_velocity): #when hit a wall or an object
		queue_free()


func _on_Area2D_area_entered(area :Area2D):
	if area.is_in_group("player"):
		area.get_parent().take_damage(1)
		queue_free()
