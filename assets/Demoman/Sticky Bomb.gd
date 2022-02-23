extends KinematicBody

var frame = 0 
var duration = 0.7
export var gravity = 15
var terminal_velocity: float = gravity * -5
export var speed:int = 0
var velocity = Vector3()
var bounce
var stick = false
var delete = false
export var explosion : PackedScene

onready var main = get_tree().current_scene

#onready var explosion_instance = explosion.instance()

func _ready():
	Globals.sticky_deployed += 1
	set_as_toplevel(true)
	#$Timer.start(duration)


func _physics_process(delta):
	if delete == true:
		Globals.sticky_deployed = 0
		queue_free()
	if Globals.sticky_deployed >= 3:
		get_tree().set_group("Sticky Bomb", "delete", true)
	if stick == false:
		velocity.y -= gravity * delta
		if velocity.y < terminal_velocity:
			velocity.y = terminal_velocity
	velocity = move_and_slide(velocity, Vector3.UP,false, 4, PI/4, false)
	bounce = move_and_collide(velocity * delta)
	if bounce:
		stick = true
		self.velocity = Vector3.ZERO
	else:
		for index in get_slide_count():
			stick = true
			self.velocity = Vector3.ZERO


func _input(event):
	if Input.is_action_just_pressed("shoot2") and $Timer.is_stopped():
		var explosion_instance = explosion.instance()
		explosion_instance.radius_val = 1.5
		explosion_instance.distance_ratio = 1
		explosion_instance.explode_force  = 15
		explosion_instance.y_explode_ratio = 1
		main.add_child(explosion_instance)
		explosion_instance.global_transform.origin = self.global_transform.origin
		Globals.sticky_deployed -= 1
		queue_free()

		
func _on_Area_area_entered(area):
	if area.name !=("Portal"):
		print("bye")
		pass
		#queue_free()


func _on_Timer_timeout():
	pass



