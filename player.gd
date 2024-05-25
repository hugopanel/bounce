extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14

var player_id # Player identifier (assigned by the level)

var target_velocity = Vector3.ZERO

var movement_left
var movement_right
var movement_up
var movement_down
var action_dash

var enabled = true
var frames_before_reenabled = 5
var enabled_counter = 0

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	
func init_controls():
	movement_left = "PA_Left" if player_id == 1 else "PB_Left"
	movement_right = "PA_Right" if player_id == 1 else "PB_Right"
	movement_up = "PA_Up" if player_id == 1 else "PB_Up"
	movement_down = "PA_Down" if player_id == 1 else "PB_Down"
	action_dash = "PA_Dash" if player_id == 1 else "PB_Dash"
 
func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed(movement_left):
		direction.x -= 1
	if Input.is_action_pressed(movement_right):
		direction.x += 1
	if Input.is_action_pressed(movement_up):
		direction.z -= 1
	if Input.is_action_pressed(movement_down):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)
	
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()

	if enabled == false:
		if enabled_counter == frames_before_reenabled:
			enabled_counter = 0
			enabled = true
		else:
			enabled_counter += 1

func _on_body_entered(body: PhysicsBody3D):
	if enabled:
		if (body.name == "RigidBody3D"):
			# Check if player is moving
			if (velocity != Vector3.ZERO):
				body.velocity = velocity * 2
				enabled = false
