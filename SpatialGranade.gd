extends KinematicBody

var frame = 0 
var duration = 5
export var speed:int = 10
var velocity = Vector3()
var bounce
onready var explosion = preload("res://assets/Soldier/Explosion_Hitbox.tscn")#: PackedScene
onready var decal = preload('res://assets/Textures/Bullet Decal.tscn')
onready var main = get_tree().current_scene

#onready var explosion_instance = explosion.instance()

func _ready():
	Globals.proj_counter += 1
	set_as_toplevel(true)
	$Timer.start(duration)


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3.UP,false, 4, PI/4, false)
	bounce = move_and_collide(velocity * delta)
#	if bounce:
#		self.rotation = Vector3(velocity.bounce(bounce.normal).x,velocity.bounce(bounce.normal).y,velocity.bounce(bounce.normal).z * 1.5)
#		velocity = velocity.bounce(bounce.normal) * 0.8
#		#var explosion_instance = explosion.instance()
#		var explosion_instance = explosion.instance()
#		explosion_instance.y_explode_ratio = 0.5
#		main.add_child(explosion_instance)
#		explosion_instance.global_transform.origin = bounce.get_position()
#		explosion_instance.transform.looking_at(-velocity.bounce(bounce.normal), Vector3.UP)
#		#print("bye")
#		queue_free()
#	else:
	for index in get_slide_count():
		if index == 0:
			var collision = get_slide_collision(index)
			var explosion_instance = explosion.instance()
			
			var decal_instance = decal.instance()
			main.add_child(decal_instance)
			decal_instance.global_transform.origin = collision.get_position()
			decal_instance.look_at(collision.get_position() + collision.get_normal()*2, Vector3.UP)
			
			explosion_instance.y_explode_ratio = 1
			main.add_child(explosion_instance)
			explosion_instance.global_transform.origin = collision.get_position()
			
			queue_free()
		#collision.normal
	#velocity = move_and_collide(velocity * delta)

func _on_Area_area_entered(area):
	if area.name !=("Portal"):
		print("bye")
		queue_free()


func _on_Timer_timeout():
	queue_free()

