extends KinematicBody

var gravity = 9.8
var speed = 8
var max_accel = 10 *speed
var jump_speed: float = 4
var mouse_sens: float = 0.01

var velocity = Vector3()
var launch = false

var snap_vector = Vector3.DOWN
var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()

export var rocket_launcher: PackedScene 
onready var camera = $Pivot/Camera
onready var guns = [$Gun0]
onready var main = get_tree().current_scene

onready var raycast = $Pivot/Camera/RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	print(velocity.y)
	var bounce = move_and_collide(velocity * delta)
	if bounce:
		print(bounce.collider.name)
#	if bounce.collider.name == "":
#		velocity = velocity.bounce(bounce.normal) * 0.8
	shoot_event()
	velocity.x = get_input_dir().x * speed
	velocity.z = get_input_dir().z * speed
	velocity.y -= gravity * delta

#	if not is_on_floor():
#		velocity.y = gravity * delta
#		snap_vector = Vector3.ZERO
#	else: 
#		velocity.y -= gravity * delta#-get_floor_normal() * delta
#		snap_vector = Vector3.DOWN
	if is_on_floor() and snap_vector == Vector3.ZERO:
		snap_vector = Vector3.DOWN
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		snap_vector = Vector3.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP)
	

func get_input_dir() -> Vector3:
	var z: float = (
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	)
	var x: float = (
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	)
	return transform.basis.xform(Vector3 (x,0,z).normalized())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		
		#Rotate body around the Y axis with each change in the mouse's X-axis input
		rotate_y(event.relative.x * mouse_sens * -1) #multiply by -1 becuase axis to mouse movement is inversed
		
		#Rotate camera around the C axis with each change in the mouse's Y-axis input
		$Pivot.rotate_x(event.relative.y * mouse_sens)
		
		#Limit rotation around x axis to looking straight up and down
		$Pivot.rotation.x = clamp($Pivot.rotation.x, deg2rad(-90),deg2rad(90))

func shoot_event():
	if Input.is_action_just_pressed("shoot1"):
		var rocket_instance = rocket_launcher.instance()
		main.add_child(rocket_instance)
		rocket_instance.global_transform.origin = guns[0].global_transform.origin
		rocket_instance.rotation_degrees = Vector3(-$Pivot.rotation_degrees.x, self.rotation_degrees.y+180,0)
		rocket_instance.velocity = rocket_instance.transform.basis.z * -rocket_instance.speed

func bounce(vector):
	print("bounce")
	velocity += vector
