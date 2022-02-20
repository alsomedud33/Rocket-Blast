# Here is all the code used for player movement.
# It's not yet complete (no going up steps and probably more features missing), and may be a bit messy
# See it in action here : https://www.youtube.com/watch?v=ALRW8pSbosE

extends KinematicBody

export var mouse_sensitivity: float = 0.01
export var max_speed: float = 6 # Meters per second
export var max_air_speed: float = 0.6
export var accel: float = 60 # or max_speed * 10 : Reach max speed in 1 / 10th of a second

# For now, the friction variable is not used, as the calculations are  not the same as quake's
# export var friction: float = 2 # Higher friction = less slippery. In quake-based games, usually between 1 and 5

export var gravity: float = 15
export var jump_impulse: float = 10
var terminal_velocity: float = gravity * -5 # When this is reached, we stop increasing falling speed

var snap: Vector3 # Needed for move_and_slide_wit_snap(), which enables to go down slopes without falling

onready var head: Spatial = $Pivot
onready var camera: Camera = $Pivot/Camera
onready var gun_camera = $CanvasLayer/ViewportContainer/Viewport/Camera
onready var raycast = $Pivot/Camera/RayCast
onready var anim = $AnimationPlayer
onready var timer = $Timer
export var rocket_launcher: PackedScene 
onready var main = get_tree().current_scene
onready var guns = $"Pivot/Camera/Rocket Launcher/Gun0"
export var cooldown = 0.8
var velocity: Vector3 = Vector3.ZERO # The current velocity vector
var wishdir: Vector3 = Vector3.ZERO # Desired travel direction of the player

var vertical_velocity: float = 0 # Vertical component of our velocity. 
# We separate it from 'velocity' to make calculations easier, then join both vectors before moving the player

var wish_jump: bool = false # If true, player has queued a jump : the jump key can be held down before hitting the ground to jump.
var auto_jump: bool = false # Auto bunnyhopping

# The next three variables are used to display corresponding vectors in game world.
# This is probably not the best solution and will be removed in the future.
var debug_horizontal_velocity: Vector3 = Vector3.ZERO
var accelerate_return: Vector3 = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event: InputEvent) -> void:
	shoot_event()
	# Camera rotation
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_x(event.relative.y * mouse_sensitivity * 1)
		self.rotate_y(event.relative.x * mouse_sensitivity * -1)
		var camera_rot = head.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		head.rotation_degrees = camera_rot


func _process(delta):
	gun_camera.global_transform = camera.global_transform

func _physics_process(delta: float) -> void:
	var forward_input: float = Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	var strafe_input: float = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	wishdir = Vector3(strafe_input, 0, forward_input).rotated(Vector3.UP, self.global_transform.basis.get_euler().y).normalized() 
	# wishdir is our normalized horizontal inpur
	
	queue_jump()
	
	if self.is_on_floor():
		if wish_jump: # If we're on the ground but wish_jump is still true, this means we've just landed
			snap = Vector3.ZERO #Set snapping to zero so we can get off the ground
			vertical_velocity = jump_impulse # Jump
			
			move_air(velocity, delta) # Mimic Quake's way of treating first frame after landing as still in the air
			
			wish_jump = false # We have jumped, the player needs to press jump key again
			
		else : # Player is on the ground. Move normally, apply friction
			vertical_velocity = -1
			snap = -get_floor_normal() #Turn snapping on, so we stick to slopes
			move_ground(velocity, delta)
	
	else: #We're in the air. Do not apply friction
		snap = Vector3.DOWN
		vertical_velocity -= gravity * delta if vertical_velocity >= terminal_velocity else 0 # Stop adding to vertical velocity once terminal velocity is reached
		move_air(velocity, delta)
	
	if self.is_on_ceiling(): #We've hit a ceiling, usually after a jump. Vertical velocity is reset to cancel any remaining jump momentum
		vertical_velocity = 0
	for i in self.get_slide_count():
		#print (state.get_contact_collider_object(i).name)
		#print(get_slide_collision(i).get_collider().name)
		if get_slide_collision(i).get_collider().name == "Explosion_Hitbox":
			velocity += get_slide_collision(i).normal *15

	if Input.is_action_pressed("shoot1") and timer.is_stopped():
	#if event is InputEventMouseButton and event.pressed and event.button_index == 1 and timer.is_stopped():
		timer.start(cooldown)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		var rocket_instance = rocket_launcher.instance()
		main.add_child(rocket_instance)
		anim.play("Shoot_Rocket")
		rocket_instance.global_transform.origin = guns.global_transform.origin
		if raycast.is_colliding():
			rocket_instance.look_at(raycast.get_collision_point(), Vector3.UP)
		else:
			rocket_instance.rotation_degrees = Vector3(-$Pivot.rotation_degrees.x+1, self.rotation_degrees.y+182,0)
		rocket_instance.velocity = rocket_instance.transform.basis.z * -rocket_instance.speed
		

# This is were we calculate the speed to add to current velocity
func accelerate(wishdir: Vector3, input_velocity: Vector3, accel: float, max_speed: float, delta: float)-> Vector3:
	# Current speed is calculated by projecting our velocity onto wishdir.
	# We can thus manipulate our wishdir to trick the engine into thinking we're going slower than we actually are, allowing us to accelerate further.
	var current_speed: float = input_velocity.dot(wishdir)
	
	# Next, we calculate the speed to be added for the next frame.
	# If our current speed is low enough, we will add the max acceleration.
	# If we're going too fast, our acceleration will be reduced (until it evenutually hits 0, where we don't add any more speed).
	var add_speed: float = clamp(max_speed - current_speed, 0, accel * delta)
	
	# Put the new velocity in a variable, so the vector can be displayed.
	accelerate_return = input_velocity + wishdir * add_speed
	return accelerate_return

# Scale down horizontal velocity
# For now, we're simply substracting 10% from our current velocity. This is not how it works in engines like idTech or Source !
func friction(input_velocity: Vector3)-> Vector3:
	var speed: float = input_velocity.length()
	var scaled_velocity: Vector3

	scaled_velocity = input_velocity * 0.9 # Reduce current velocity by 10%
	
	# If the player is moving too slowly, we stop them completely
	if scaled_velocity.length() < max_speed / 100:
		scaled_velocity = Vector3.ZERO

	return scaled_velocity

# Apply friction, then accelerate
func move_ground(input_velocity: Vector3, delta: float)-> void:
	# We first work on only on the horizontal components of our current velocity
	var nextVelocity: Vector3 = Vector3.ZERO
	nextVelocity.x = input_velocity.x
	nextVelocity.z = input_velocity.z
	nextVelocity = friction(nextVelocity) #Scale down velocity
	nextVelocity = accelerate(wishdir, nextVelocity, accel, max_speed, delta)
	
	# Then get back our vertical component, and move the player
	nextVelocity.y = vertical_velocity
	velocity = move_and_slide_with_snap(nextVelocity, snap, Vector3.UP,true)

# Accelerate without applying friction (with a lower allowed max_speed)
func move_air(input_velocity: Vector3, delta: float)-> void:
	# We first work on only on the horizontal components of our current velocity
	var nextVelocity: Vector3 = Vector3.ZERO
	nextVelocity.x = input_velocity.x
	nextVelocity.z = input_velocity.z
	nextVelocity = accelerate(wishdir, nextVelocity, accel, max_air_speed, delta)
	
	# Then get back our vertical component, and move the player
	nextVelocity.y = vertical_velocity
	velocity = move_and_slide_with_snap(nextVelocity, snap, Vector3.UP,true)

# Set wish_jump depending on player input.
func queue_jump()-> void:
	# If auto_jump is true, the player keeps jumping as long as the key is kept down
	if auto_jump:
		wish_jump = true if Input.is_action_pressed("jump") else false
		return
	
	if Input.is_action_pressed("jump") and !wish_jump:
		wish_jump = true
	if Input.is_action_just_released("jump"):
		wish_jump = false

func shoot_event():
	pass 
