extends StaticBody2D

@export var speed:float
@export var addX:float
@export var addY:float
var startX:float
var startY:float

func _ready():
	startX = position.x
	startY = position.y

func _process(delta):
	position = position.move_toward(Vector2(startX+addX,startY+addY), delta * speed)
