extends CharacterBody2D
 
@export var JUMP_VELOCITY = -500
@export var TOP_SPEED = 400
@export var RESPAWNTHRESHHOLD = 1500
@export var BASE_SPEED = 100
@export var ACCELERATION_AMOUNT = 1.1
@export var DECELERATION_AMOUNT = 1.1
@export var MAX_DASH_COOLDOWN = 3000
@export var DASH_SPEED = 150
@export var landing_curve = 0
@export var speedCurve = Curve
@export var respawn_xpos = 500
@export var respawn_ypos = 300
var JUMPS = 2
var jumpAmount = 2
var dashCooldown = 0
var deltaTime = 1
var moveTime = 1000
var health = 100
var was_on_floor
var currentSpeed = 1
@onready var gun = $Gun
@onready var coyoteTimer: Timer = $CoyoteTimer
@onready var lastTime = Time.get_ticks_msec()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _respawn():
	if position.y >= RESPAWNTHRESHHOLD:
		position.y = respawn_ypos
		position.x = respawn_xpos

func _accelerate(speed, targetSpeed):
	if speed >= targetSpeed:
		return targetSpeed
	
	return speed * ACCELERATION_AMOUNT

func _decellerate(speed, targetSpeed):
	if speed <= targetSpeed:
		return targetSpeed
	
	return speed / DECELERATION_AMOUNT

func _jump(onFloor, jumps):
	if not onFloor and coyoteTimer.is_stopped():
		jumps -= 1
	velocity.y = JUMP_VELOCITY
	jumps -= 1
	return jumps

func _coyoteTime(on_floor):
	if was_on_floor and not on_floor:
		coyoteTimer.start()
	was_on_floor = on_floor

func _draw():
	if dashCooldown > 0:
		draw_string(Control.new().get_theme_font("Arial"), Vector2(-float(get_window().size.x)/2 + 10, -float(get_window().size.y)/2 + 20), "Dash: " + str(round(float(dashCooldown) / 1000)))
	draw_string(Control.new().get_theme_font("Arial"), Vector2(-float(get_window().size.x)/2 + 10, float(get_window().size.y)/2 - 20), "Ammo: " + str(gun.currentGun.ammo))

func _process(_delta):
	queue_redraw()
	if Global._getIsMultiplayer():
		GameServer._sendRequest("updatePlayer?id=" + GameServer.playerID + "&x=" + str(round(position.x)) + "&y=" + str(round(position.y)) + "&rotation=" + str(round(gun.rotation_degrees)))

func _notification(notification: int):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		Global._handleGameQuit()

func _physics_process(delta):
	# Calculate Deltatime
	deltaTime = Time.get_ticks_msec() - lastTime
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumpAmount = JUMPS	
	# Handles the coyote Time
	_coyoteTime(is_on_floor())
	_respawn()
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and jumpAmount > 0:
		jumpAmount = _jump(is_on_floor(), jumpAmount)
		
	#The input direction
	var direction = Input.get_axis("left", "right")

	# Handle movement
	if direction:
		currentSpeed = _accelerate(currentSpeed, TOP_SPEED)
		velocity.x = direction * currentSpeed
	else:
		currentSpeed = 100
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
	
	# Handle dash
	if dashCooldown > 0:
		dashCooldown -= 1 * deltaTime
	
	if Input.is_action_just_pressed("dash") and dashCooldown <= 0 or moveTime < 100:
		if moveTime >= 100:
			moveTime = 0
		moveTime += 1 * deltaTime
		velocity.x += direction * DASH_SPEED * deltaTime
		dashCooldown = MAX_DASH_COOLDOWN

	move_and_slide()
	lastTime = Time.get_ticks_msec()
