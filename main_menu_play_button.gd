extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()
	self.pressed.connect(func(): get_tree().change_scene_to_file("res://MainLevel.tscn"))
	# pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
