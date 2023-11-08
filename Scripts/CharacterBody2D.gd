extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -475.0
var jumped = false
var dashCooldown = 0
var deltaTime = 1
var lastTime = Time.get_ticks_msec()
var moveTime = 1000
var health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _draw():
	if dashCooldown > 0:
		draw_string(Control.new().get_theme_font("Arial"), Vector2(-float(get_window().size.x)/2 + 10, -float(get_window().size.y)/2 + 20), "Dash: " + str(round(float(dashCooldown) / 1000)))
		
func _process(_delta):
	queue_redraw()

func _physics_process(delta):
	# Calculate Deltatime
	deltaTime = Time.get_ticks_msec() - lastTime
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if is_on_floor():
		jumped = false
		
	if Input.is_action_just_pressed("jump") and ((is_on_floor() or not jumped) or (not is_on_floor() and not jumped)):
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			jumped = true
			
	#The input direction
	var direction = Input.get_axis("left", "right")

	# Handle movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle dash
	if dashCooldown > 0:
		dashCooldown -= 1 * deltaTime
	
	if Input.is_action_just_pressed("dash") and dashCooldown <= 0 or moveTime < 100:
		if moveTime >= 100:
			moveTime = 0
		moveTime += 1 * deltaTime
		velocity.x += direction * 150 * deltaTime
		dashCooldown = 3000

	move_and_slide()
	lastTime = Time.get_ticks_msec()
