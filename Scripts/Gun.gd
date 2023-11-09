extends Node2D

var current_bullets = []
@onready var bullet = preload("res://Objects/Bullet.tscn")

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("fire"):
		var bullet_instantiated = bullet.instantiate()
		bullet_instantiated.set("rotation", rotation)
		bullet_instantiated.set("position.x", position.x)
		bullet_instantiated.set("position.y", position.y)
		current_bullets.append(bullet_instantiated)
		get_tree().current_scene.add_child(bullet_instantiated)
