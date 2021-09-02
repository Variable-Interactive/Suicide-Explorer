extends RigidBody2D

#Variables for bullet
export(float) var bullet_force = 1000
export(float) var damage = 10


func _ready() -> void:
	#Add Impulse as soon as bullet enters the scene
	apply_impulse(Vector2.ZERO, transform.x * bullet_force)


func _process(_delta: float) -> void:
	#since angular velocity changes slightly on collision...
	#...so we will be using it for collision detection with tile maps (did this cause i don't know of better way for collision detection with tilemaps)
	
	if not is_equal_approx(0, angular_velocity): #when bullet hits a wall or an object
		#delete it
		queue_free()
		#NOTE: dont worry about it deleting before hitting the player...
		#...to do that it has to enter it's area first and so method below will automatically run first


#Responsible for damaging the player
func _on_Area2D_area_entered(area :Area2D):
	if area.is_in_group("player"):
		area.get_parent().take_damage(1)
		queue_free()
