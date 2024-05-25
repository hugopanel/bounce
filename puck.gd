extends RigidBody3D

var velocity: Vector3 = Vector3.ZERO

var max_velocity = 10
var min_velocity = 10

func _ready():
	pass

func _physics_process(delta):
	velocity.y = 0
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		if collision_info.get("name") != "Player"||collision_info.get_collider_velocity() == Vector3.ZERO:
			velocity = velocity.bounce(collision_info.get_normal())
