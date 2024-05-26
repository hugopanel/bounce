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

# var enabled = true
# var frames_before_reenabled = 5
# var enabled_counter = 0

var available_dashes = 0
var max_dashes = 4
var dashing = false

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$NewDashTimer.timeout.connect(_new_dash_timer_timeout)
	$NewDashTimer.start()
	$DashingTimer.timeout.connect(_dashing_timer_timeout)
	
func init_controls():
	movement_left = "PA_Left" if player_id == 1 else "PB_Left"
	movement_right = "PA_Right" if player_id == 1 else "PB_Right"
	movement_up = "PA_Up" if player_id == 1 else "PB_Up"
	movement_down = "PA_Down" if player_id == 1 else "PB_Down"
	action_dash = "PA_Dash" if player_id == 1 else "PB_Dash"
 
func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	var target_speed = speed
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed(movement_left):
		direction.x -= 1
	if Input.is_action_pressed(movement_right):
		direction.x += 1
	if Input.is_action_pressed(movement_up):
		direction.z -= 1
	if Input.is_action_pressed(movement_down):
		direction.z += 1

	if Input.is_action_just_pressed(action_dash):
		if dashing == false&&velocity != Vector3.ZERO: # We don't want to consume another dash if the player is already dashing
			# Check if player can dash
			if (available_dashes > 0):
				available_dashes -= 1
				$NewDashTimer.start()
				$DashingTimer.start()
				dashing = true
				# self.add_child()
	
	# If player is dashing...
	if dashing:
		target_speed = speed * 3
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)
	
	# Ground velocity
	target_velocity.x = direction.x * target_speed
	target_velocity.z = direction.z * target_speed
	
	velocity = target_velocity
	move_and_slide()

	# if enabled == false:
	# 	if enabled_counter == frames_before_reenabled:
	# 		enabled_counter = 0
	# 		enabled = true
	# 		print("Reenabled player " + str(player_id))
	# 	else:
	# 		enabled_counter += 1

func _on_body_entered(body: PhysicsBody3D):
	# if enabled:
	if (body.name == "Puck"):
		# Check if player is moving
		if (velocity != Vector3.ZERO):
			body.velocity = velocity.normalized() * speed * 2
			# enabled = false
			dashing = false

func _new_dash_timer_timeout():
	if (available_dashes < max_dashes):
		available_dashes += 1
		$NewDashTimer.start()

func _dashing_timer_timeout():
	dashing = false
