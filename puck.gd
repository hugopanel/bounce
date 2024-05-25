extends RigidBody3D

var velocity: Vector3 = Vector3.ZERO

var max_velocity = 10

func _ready():
	#velocity.x = 0.1
	pass

func _physics_process(delta):
	velocity.y = 0
	var collision_info = move_and_collide(velocity * delta)
	#position += velocity * delta
	#
	if collision_info:
		if collision_info.get("name") != "Player":
			velocity = velocity.bounce(collision_info.get_normal())
			
	for body in $Area3D.get_overlapping_bodies():
		if body.name == "Player" && body.velocity != Vector3.ZERO:
			print(body.velocity)
			velocity += body.velocity
			print(velocity)
			
	if (abs(velocity.x) > max_velocity): velocity.x = max_velocity * sign(velocity.x)
	if (abs(velocity.y) > max_velocity): velocity.y = max_velocity * sign(velocity.y)
