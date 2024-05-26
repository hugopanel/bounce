extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(func(): get_tree().quit())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
