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
export var explosion = preload("res://assets/Soldier/Explosion_Hitbox.tscn")#: PackedScene

onready var main = get_tree().current_scene
onready var tick = preload("res://assets/Sounds/Demoman/Explosion Tick.wav")
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
		for members in range(0,get_tree().get_nodes_in_group("Sticky Bomb").size()):
			if members == 0:
				get_tree().get_nodes_in_group("Sticky Bomb")[members].explode()
	if stick == false:
		velocity.y -= gravity * delta
		if velocity.y < terminal_velocity:
			velocity.y = terminal_velocity
	velocity = move_and_slide(velocity, Vector3.UP,false, 4, PI/4, false)
	bounce = move_and_collide(velocity * delta)
	if bounce:
		stick = true
		self.velocity = Vector3.ZERO
		if Globals.sticky_deployed >= 2:
			for members in range(0,get_tree().get_nodes_in_group("Sticky Bomb").size()):
				if members == 0:
					get_tree().get_nodes_in_group("Sticky Bomb")[members].explode()
	else:
		for index in get_slide_count():
			stick = true
			self.velocity = Vector3.ZERO
			if Globals.sticky_deployed >= 2:
				for members in range(0,get_tree().get_nodes_in_group("Sticky Bomb").size()):
					if members == 0:
						get_tree().get_nodes_in_group("Sticky Bomb")[members].explode()
func _process(delta):
	if Input.is_action_just_pressed("shoot2") and $Timer.is_stopped():
		var tick_sound = AudioStreamPlayer.new()
		tick_sound.stream = tick
		tick_sound.set_volume_db(-12)
		main.add_child(tick_sound)
		tick_sound.play()
		explode()

func explode():
		var explosion_instance = explosion.instance()
		explosion_instance.radius_val = 1.5
		explosion_instance.distance_ratio = 1
		explosion_instance.explode_force  = 12
		explosion_instance.y_explode_ratio = 0.5
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



