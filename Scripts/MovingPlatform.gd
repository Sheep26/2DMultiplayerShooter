extends StaticBody2D

@export var speed:float
@export var addX:float
@export var addY:float
var startX:float
var startY:float

func _ready():
	startX = position.x
	startY = position.y

func _process(_delta):
	pass
