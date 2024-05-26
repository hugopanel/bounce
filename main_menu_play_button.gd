extends TextureButton

var timer = Timer.new() # Crée un nouveau Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	
	self.pressed.connect(click)
	
	# Configure le Timer
	timer.wait_time = 0.2 # Le Timer attendra 0.2 seconde
	timer.one_shot = true # Le Timer ne se répétera pas
	timer.timeout.connect(on_timer_timeout) # Connecte le signal timeout du Timer à une fonction
	add_child(timer) # Ajoute le Timer comme enfant de ce nœud

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func click():
	if $"../AudioStreamPlayer2D".playing == false:
		timer.start() # Démarre le Timer
	$"../AudioStreamPlayer2D".play()

# Cette fonction sera appelée lorsque le Timer atteindra 0
func on_timer_timeout():
	get_tree().change_scene_to_file("res://MainLevel.tscn")
