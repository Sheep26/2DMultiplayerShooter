extends StaticBody2D

@export var speed:float
@export var add = Vector2()
var start = Vector2()
var goto = true

func _ready():
	start = position

func _process(delta):
	if goto:
		position = position.move_toward(start, delta * speed)
	else:
		position = position.move_toward(start + add , delta * speed)
	if position == start:
		goto = false
	elif position == start + add:
		goto = true 
