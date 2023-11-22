extends Node2D
const KNOCKBACK_STRENGTH = 300
var currentGun: GunType
@onready var bullet = preload("res://Objects/Bullet.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var glock18: GunType = GunType.new(0, "Glock-18", "Pistol", "res://Assets/Guns/Glock18.png", $Guns/pistol/firerateTimer, $Guns/pistol/reloadTimer, 23, false)
@onready var ak47: GunType = GunType.new(1, "AK47", "Rifle", "res://Assets/Guns/AK47.png", $Guns/ak47/firerateTimer, $Guns/ak47/reloadTimer, 35, true)
var guns = []

class GunType:
	var id: int
	var gunName: String
	var category: String
	var firerate: Timer
	var reloadTimer: Timer
	var ammo: int
	var maxAmmo: int
	var auto: bool
	var canShoot: bool
	var texturePath: String
	var texture: Texture2D
	
	func _init(id: int, gunNameArg: String, categoryArg: String, texturePathArg: String, firerateArg: Timer, reloadTimerArg: Timer, ammoArg: int, autoArg):
		gunName = gunNameArg
		firerate = firerateArg
		reloadTimer = reloadTimerArg
		ammo = ammoArg
		maxAmmo = ammoArg
		auto = autoArg
		category = categoryArg
		texturePath = texturePathArg
		canShoot = true
		firerate.connect("timeout", _firerateTimerEnded)
		reloadTimer.connect("timeout", _reloadTimerEnded)
		
	func _reload():
		canShoot = false
		reloadTimer.start()
		
	func _reloadTimerEnded():
		reloadTimer.stop()
		canShoot = true
		ammo = maxAmmo
	
	func _firerateTimerEnded():
		canShoot = true
		firerate.stop()

func _ready():
	guns.append(glock18)
	guns.append(ak47)
	currentGun = glock18
	
func _getGunFromID(id: int) -> GunType:
	for gun in guns:
		if gun.id == id:
			return gun
	return null

func _shoot(rotationToVector2):
	get_parent().velocity.y = -(rotationToVector2.y * KNOCKBACK_STRENGTH) 
	get_parent().velocity.x = -(rotationToVector2.x * KNOCKBACK_STRENGTH * 4) 
	var bullet_instantiated = bullet.instantiate()
	bullet_instantiated.rotation = rotation
	bullet_instantiated.position = position + get_parent().position + rotationToVector2 * 94
	get_tree().current_scene.add_child(bullet_instantiated)
	currentGun.ammo -= 1
	currentGun.canShoot = false
	currentGun.firerate.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var rotationToVector2 = Vector2(cos(rotation), sin(rotation))
	rotate(get_angle_to(get_global_mouse_position()))
	if Input.is_action_just_pressed("reload"):
		currentGun._reload()
	if (Input.is_action_just_pressed("fire") or (currentGun.auto and Input.is_action_pressed("fire"))) and currentGun.ammo > 0 and currentGun.canShoot:
		_shoot(rotationToVector2)
