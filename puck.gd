extends RigidBody3D

var velocity: Vector3 = Vector3.ZERO

var max_velocity = 30
var min_velocity = 10

func _ready():
	print($Area3D.is_monitoring())
	$Area3D.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	velocity.y = 0
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		if collision_info.get("name") != "Player" || collision_info.get_collider_velocity() == Vector3.ZERO:
			velocity = velocity.bounce(collision_info.get_normal())
	
	#for body in $Area3D.get_overlapping_bodies():
		#if body.name == "Player" && body.velocity != Vector3.ZERO:
			#print(body.velocity)
			#velocity += body.velocity
			#print(velocity)
	
	# Set max velocity
	if (abs(velocity.x) > max_velocity): velocity.x = max_velocity * sign(velocity.x)
	if (abs(velocity.y) > max_velocity): velocity.y = max_velocity * sign(velocity.y)
	
	# Set min velocity
	if (abs(velocity.x) < min_velocity || abs(velocity.y) < min_velocity):
		velocity = velocity.normalized() * min_velocity

func _on_body_entered(body: PhysicsBody3D):
	if body.name == "Player" && body.velocity != Vector3.ZERO:
		print(body.velocity)
		velocity = body.velocity * 2
		print(velocity)
