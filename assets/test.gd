extends RigidBody

var gravity = 9.8
var speed = 1
var max_accel = 10 #*speed
var jump_speed: float = 4
var mouse_sens: float = 0.01
var mouseSpeed:Vector2
var velocity = Vector3()
var launch = false
var wish_dir = Vector2()

var move_x: float 
var move_z: float 

var snap_vector = Vector3.DOWN
var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()
export var accel: float = 60


export var rocket_launcher: PackedScene 
onready var camera = $Pivot/Camera
onready var guns = [$Gun0]
onready var main = get_tree().current_scene

onready var raycast = $Pivot/Camera/RayCast

var accelerate_return: Vector3 = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _integrate_forces(state):
	print(linear_velocity)
#	if abs(get_linear_velocity().x) > max_accel or abs(get_linear_velocity().y) > max_accel:
#		var new_accel = get_linear_velocity().normalized()
#		new_accel *= max_accel
#		set_linear_velocity(new_accel)
	#print (linear_velocity.length())
	self.rotation.y = mouseSpeed.x * -mouse_sens #multiply by -1 becuase axis to mouse movement is inversed
	#Rotate camera around the C axis with each change in the mouse's Y-axis input
	#print (mouseSpeed.y)
	$Pivot.rotation.x = mouseSpeed.y * mouse_sens
	#Limit rotation around x axis to looking straight up and down
	$Pivot.rotation.x = clamp($Pivot.rotation.x, deg2rad(-90),deg2rad(90))

#	if bounce.collider.name == "":
#		velocity = velocity.bounce(bounce.normal) * 0.8
	shoot_event()
	get_input_dir()
#	velocity.x = get_input_dir().x 
#	velocity.z = get_input_dir().z 
	if Input.is_action_just_pressed("jump"):
		apply_impulse(global_transform.origin,Vector3(0,jump_speed,0)) 

	add_force(velocity*speed,global_transform.origin)
	for i in state.get_contact_count():
		
		#print (state.get_contact_collider_object(i).name)
		if state.get_contact_collider_object(i):
			if state.get_contact_collider_object(i).name =="Explosion_Hitbox":
				apply_impulse(global_transform.origin,state.get_contact_local_normal(i)*0.1)

	

func get_input_dir():
	move_z= (
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	)
	move_x= (
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	)
	#return transform.basis.xform(Vector3 (move_x,0,move_z).normalized())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		var motion:InputEventMouseMotion = event
		if (motion!= null):
			mouseSpeed.y += motion.relative.y;
			mouseSpeed.y = clamp (mouseSpeed.y,-160, 160)
			mouseSpeed.x += motion.relative.x;

func shoot_event():
	if Input.is_action_just_pressed("shoot1"):
		var rocket_instance = rocket_launcher.instance()
		main.add_child(rocket_instance)
		rocket_instance.global_transform.origin = guns[0].global_transform.origin
		rocket_instance.rotation_degrees = Vector3(-$Pivot.rotation_degrees.x, self.rotation_degrees.y+180,0)
		rocket_instance.velocity = rocket_instance.transform.basis.z * -rocket_instance.speed

