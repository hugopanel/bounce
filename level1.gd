extends Node3D

@export var min_distance_between_obstacles: float = 10.0
@export var max_attempts: int = 1000

@export var PA_Score: int = 0
@export var PB_Score: int = 0

var ui
var PA_Score_Label
var PB_Score_Label

var timer_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add the obstacles to the map
	add_obstacles($ObstaclesArea, $ObstaclesAreaAvoid, 5)

	# $UI.get_node("Panel/PA_Score").text = "99"
	ui = get_node("CanvasLayer/UI")
	PA_Score_Label = ui.get_node("Scores/PA_Score")
	PB_Score_Label = ui.get_node("Scores/PB_Score")

	# Instanciate player 1
	var player1 = preload ("res://player.tscn").instantiate()
	player1.player_id = 1
	player1.position.x -= 20
	player1.init_controls()
	add_child(player1)
	$AudioStreamPlayer3D3.play()
	
	# Instanciate player 2
	var player2 = preload ("res://player.tscn").instantiate()
	player2.player_id = 2
	player2.position.x += 20
	player2.init_controls()
	add_child(player2)

	# Bind signals for dashes to update the progress bars
	player1.dash1_changed.connect(func(percentage: float): ui.get_node("PA_Dash_Container/PA_Dash_1").value=percentage)
	player1.dash2_changed.connect(func(percentage: float): ui.get_node("PA_Dash_Container/PA_Dash_2").value=percentage)
	player1.dash3_changed.connect(func(percentage: float): ui.get_node("PA_Dash_Container/PA_Dash_3").value=percentage)
	player1.dash4_changed.connect(func(percentage: float): ui.get_node("PA_Dash_Container/PA_Dash_4").value=percentage)

	player2.dash1_changed.connect(func(percentage: float): ui.get_node("PB_Dash_Container/PB_Dash_1").value=percentage)
	player2.dash2_changed.connect(func(percentage: float): ui.get_node("PB_Dash_Container/PB_Dash_2").value=percentage)
	player2.dash3_changed.connect(func(percentage: float): ui.get_node("PB_Dash_Container/PB_Dash_3").value=percentage)
	player2.dash4_changed.connect(func(percentage: float): ui.get_node("PB_Dash_Container/PB_Dash_4").value=percentage)

	# Bind signals to start the game timer when the puck is shot for the first time
	player1.puck_shot.connect(start_game_timer)
	player2.puck_shot.connect(start_game_timer)

func add_obstacles(spawn_area: Area3D, non_spawn_area: Area3D, number_of_obstacles: int):
	# List of all the possible obstacles
	var obstacles = [
		preload ("res://Obstacle1.tscn"),
		# preload ("res://Obstacle2.tscn"),
		preload ("res://Obstacle3.tscn"),
		preload ("res://Obstacle4.tscn")
	]

	var spawned_obstacles = []
	for i in range(number_of_obstacles):
		var attempts = 0
		var spawned = false

		while attempts < max_attempts:
			attempts += 1
			var random_position = get_random_position_in_area(spawn_area)
			if is_position_valid(random_position, spawned_obstacles, non_spawn_area):
				var new_obstacle = obstacles[randi() % obstacles.size()].instantiate()
				new_obstacle.position = random_position
				new_obstacle.rotation.y = randf_range(0, 360)
				new_obstacle.connect("PA_scored", _on_PA_scored)
				new_obstacle.connect("PB_scored", _on_PB_scored)
				add_child(new_obstacle)
				spawned = true
				spawned_obstacles.append(new_obstacle)
				break
		if !spawned:
			print("Couldn't spawn obstacle")
			continue

	# # Place a random obstacle in the middle of the map
	# var obstacle = obstacles[randi() % 4].instantiate()
	# add_child(obstacle)

	# # Change color of obstacle
	# var obstacle_plane = obstacle.get_node("StaticBody3D/MeshInstance")
	# var material = obstacle_plane.mesh.surface_get_material(0)
	# material.albedo_color = Color(1, 0, 0)
	# obstacle_plane.mesh.surface_set_material(0, material)

func get_random_position_in_area(area: Area3D) -> Vector3:
	var collision_shape = area.get_child(0) as CollisionShape3D
	if collision_shape:
		var shape = collision_shape.shape
		if shape is BoxShape3D:
			var box = shape as BoxShape3D
			var extents = box.extents
			var area_origin = area.global_transform.origin
			var random_position = Vector3(
				randf_range(area_origin.x - extents.x, area_origin.x + extents.x),
				0,
				randf_range(area_origin.z - extents.z, area_origin.z + extents.z)
			)
			return random_position
	return Vector3.ZERO

func is_position_valid(new_position: Vector3, existing_obstacles: Array, non_spawn_area: Area3D) -> bool:
	for obstacle in existing_obstacles:
		if obstacle.transform.origin.distance_to(new_position) < min_distance_between_obstacles:
			return false
	# Check for overlap with non spawn area
	var non_spawn_shape = non_spawn_area.get_child(0) as CollisionShape3D
	if non_spawn_shape:
		var shape = non_spawn_shape.shape
		if shape is BoxShape3D:
			var box = shape as BoxShape3D
			var extents = box.extents
			var non_spawn_area_origin = non_spawn_area.global_transform.origin
			if new_position.x > non_spawn_area_origin.x - extents.x and new_position.x < non_spawn_area_origin.x + extents.x and new_position.z > non_spawn_area_origin.z - extents.z and new_position.z < non_spawn_area_origin.z + extents.z:
				return false
	return true

func _on_PA_scored():
	PA_Score += 1
	print("PA SCORE " + str(PA_Score))
	PA_Score_Label.text = str(PA_Score)
	if $AudioStreamPlayer3D4.playing() == false:
		$AudioStreamPlayer3D4.play()

func _on_PB_scored():
	PB_Score += 1
	print("PB SCORE " + str(PB_Score))
	PB_Score_Label.text = str(PB_Score)
	if $AudioStreamPlayer3D4.playing() == false:
		$AudioStreamPlayer3D4.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ui.get_node("Scores/TimeLeft").text = str(round($GameTimer.time_left))

func start_game_timer():
	if (!timer_started):
		timer_started = true
		$GameTimer.start()
