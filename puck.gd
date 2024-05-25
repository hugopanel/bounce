extends RigidBody3D

var velocity: Vector3 = Vector3.ZERO

func _ready():
	velocity.x = 0.1

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
