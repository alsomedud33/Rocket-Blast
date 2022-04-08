extends KinematicBody

var frame = 0 
var duration = 5
export var speed:int = 10
var velocity = Vector3()
var bounce
var rocket_owner = ""
var real = false
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
	#if real:
	Network.emit_signal("rocket_hit",name,0,0)
#	for index in get_slide_count():
#		#print (get_slide_collision(index).get_collider().name)
#		if index == 0 and get_slide_collision(index).get_collider().name !=rocket_owner:
#			if real == true:
#				var collision = get_slide_collision(index)
#				var explosion_instance = explosion.instance()
#
#				var decal_instance = decal.instance()
#				main.add_child(decal_instance)
#				decal_instance.transform.origin = collision.get_position()
#				print ($RayCast.get_collision_point())
#				decal_instance.look_at(collision.get_position() + collision.get_normal() , Vector3.UP)
#
#				explosion_instance.y_explode_ratio = 1
#				main.add_child(explosion_instance)
#				explosion_instance.global_transform.origin = collision.get_position()
#				queue_free()


func _on_Area_area_entered(area):
	if area.name !=("Portal"):
		print("bye")
		queue_free()


func _on_Timer_timeout():
	Network.emit_signal("destroy_rocket",name)
	#queue_free()

