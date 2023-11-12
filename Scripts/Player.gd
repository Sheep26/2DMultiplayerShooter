extends CharacterBody2D


const TOP_SPEED = 0.1
const JUMP_VELOCITY = -475.0
const JUMPS = 2
const SPEED_CHANGES_PER_SECOND = 5.0
var jumpAmount = 2
var dashCooldown = 0
var deltaTime = 1
var moveTime = 1000
var health = 100
var was_on_floor
var currentSpeed = 1
var speedChange = 0.0
@onready var coyoteTimer = $CoyoteTimer
@onready var speedChangeTimer = $SpeedChange
@onready var lastTime = Time.get_ticks_msec()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _accelerationAndMovement(direction, speedChange):
	if speedChange >= TOP_SPEED:
		velocity.x = direction * TOP_SPEED
	velocity.x = direction * speedChange
	return velocity.x
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
		
func _process(_delta):
	queue_redraw()
func _ready():
	speedChangeTimer.set_wait_time(1/SPEED_CHANGES_PER_SECOND)
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
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and jumpAmount > 0:
		jumpAmount = _jump(is_on_floor(), jumpAmount)
		
	#The input direction
	var direction = Input.get_axis("left", "right")

	# Handle movement

	if direction: 
		speedChange = currentSpeed * 1.2
		currentSpeed = _accelerationAndMovement(direction, speedChange)
	
	# Handle dash
	if dashCooldown > 0:
		dashCooldown -= 1 * deltaTime
	
	if Input.is_action_just_pressed("dash") and dashCooldown <= 0 or moveTime < 100:
		if moveTime >= 100:
			moveTime = 0
		moveTime += 1 * deltaTime
		velocity.x += direction * 175 * deltaTime
		dashCooldown = 3000

	move_and_slide()
	lastTime = Time.get_ticks_msec()
