extends StaticBody2D

@export var speed:int
@export var addX:int
@export var addY:int
var startX:int
var startY:int

func _ready():
	startX = position.x
	startY = position.y

func _process(delta):
	pass
