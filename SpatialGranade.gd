extends KinematicBody

var frame = 0 
var duration = 5
export var speed:int = 10
var velocity = Vector3()
var bounce
export var explosion : PackedScene

onready var main = get_tree().current_scene

onready var explosion_instance = explosion.instance()

func _ready():
	set_as_toplevel(true)
	$Timer.start(duration)

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3.UP,false, 4, PI/4, false)
	bounce = move_and_collide(velocity * delta)
	if bounce:
		self.rotation = Vector3(velocity.bounce(bounce.normal).x,velocity.bounce(bounce.normal).y,velocity.bounce(bounce.normal).z * 1.5)
		velocity = velocity.bounce(bounce.normal) * 0.8
		#var explosion_instance = explosion.instance()
		main.add_child(explosion_instance)
		explosion_instance.global_transform.origin = bounce.get_position()
		explosion_instance.transform.looking_at(-velocity.bounce(bounce.normal), Vector3.UP)
		#print("bye")
		queue_free()
	else:
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			main.add_child(explosion_instance)
			explosion_instance.global_transform.origin = collision.get_position()
			
			queue_free()
		#collision.normal
	#velocity = move_and_collide(velocity * delta)
func _on_Area_area_entered(area):
	print("bye")
	queue_free()


func _on_Timer_timeout():
	queue_free()



