extends Node2D
const KNOCKBACK_STRENGTH = 400
@onready var bullet = preload("res://Objects/Bullet.tscn")
@onready var reloadTimer: Timer = $reloadTimer
@onready var firerateTimer: Timer = $firerateTimer
var currentGun: GunType
var pistol: GunType = GunType.new("pistol", 10, 2, 23, false)

class GunType:
	var gunName: String
	var firerate: float
	var reloadTime: float
	var ammo: int
	var auto: bool
	
	func _init(gunNameArg, firerateArg, reloadTimeArg, ammoArg, autoArg):
		self.gunName = gunNameArg
		self.firerate = firerateArg
		self.reloadTime = reloadTimeArg
		self.ammo = ammoArg
		self.auto = autoArg

func _ready():
	currentGun = pistol

func _shoot(rotationToVector2):
	get_parent().velocity.y = -(rotationToVector2.y * KNOCKBACK_STRENGTH) 
	var bullet_instantiated = bullet.instantiate()
	bullet_instantiated.rotation = rotation
	bullet_instantiated.position = position + get_parent().position + rotationToVector2 * 94
	get_tree().current_scene.add_child(bullet_instantiated)
	currentGun.ammo -= 1
	firerateTimer.start(1 / currentGun.firerate)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var rotationToVector2 = Vector2(cos(rotation), sin(rotation))
	rotate(get_angle_to(get_global_mouse_position()))
	# Firerate doesn't work idk why but it doesn't stop
	if (Input.is_action_just_pressed("fire") or (currentGun.auto and Input.is_action_pressed("fire"))) and currentGun.ammo > 0 and firerateTimer.is_stopped():
		_shoot(rotationToVector2)
