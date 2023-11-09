extends Node2D
const KNOCKBACK_STRENGTH = 200
var current_bullets = []
@onready var bullet = preload("res://Objects/Bullet.tscn")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var rotationToVector2 = Vector2(cos(rotation), sin(rotation))
	rotate(get_angle_to(get_global_mouse_position()))
	if Input.is_action_just_pressed("fire"):
		get_parent().velocity = -(rotationToVector2 * KNOCKBACK_STRENGTH)
		var bullet_instantiated = bullet.instantiate()
		bullet_instantiated.rotation = rotation
		bullet_instantiated.position = position + get_parent().position + rotationToVector2 * 94
		get_tree().current_scene.add_child(bullet_instantiated)
