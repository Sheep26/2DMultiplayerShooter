extends Node2D

var current_bullets = []
@onready var bullet = preload("res://Objects/Bullet.tscn")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var vector2Offset = Vector2(cos(rotation), sin(deg_to_rad(rotation))) * 94
	rotate(get_angle_to(get_global_mouse_position()))
	if Input.is_action_just_pressed("fire"):
		var bullet_instantiated = bullet.instantiate()
		bullet_instantiated.rotation = rotation
		bullet_instantiated.position = position + get_parent().position +  vector2Offset
		get_tree().current_scene.add_child(bullet_instantiated)
