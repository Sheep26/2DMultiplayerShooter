extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _button_pressed():
	get_tree().current_scene.queue_free()
	var s = ResourceLoader.load("res://Scenes/Levels/node_2d.tscn")
	var new = s.instantiate()
	get_tree().root.add_child(new)
	get_tree().current_scene = new
