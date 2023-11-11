extends Node2D

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var rotationToVector2 = Vector2(cos(rotation), sin(rotation))
	position.x += rotationToVector2.x * 10
	position.y += rotationToVector2.y * 10
