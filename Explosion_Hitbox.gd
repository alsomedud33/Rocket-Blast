extends Area

export var duration = 0.6
var velocity = Vector3()
var bounce_normal = Vector3()
export (PackedScene) onready var partical

onready var partical_instance = partical.instance()

onready var main = get_tree().current_scene

export var explode_force = 1
var collision_point
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(duration)
	main.add_child(partical_instance)
	print (self.global_transform.origin)
	partical_instance.global_translate(self.translation) 
	partical_instance.scale = Vector3(0.01,0.01,0.01)

func _process(delta):
	partical_instance.global_transform.origin = self.global_transform.origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	#var bounce = move_and_collide(velocity * delta)
#	var collision = move_and_slide(velocity)
#	for i in get_slide_count():
#		var bounce = get_slide_collision(i)
#		if bounce:
#			if bounce.collider.has_method("bounce"):
#				bounce.collider.bounce(-bounce.get_normal() *10)
#				print ("bounce")



func _on_Timer_timeout():
	queue_free()



func _on_Explosion_Hitbox_body_entered(body):
	body.snap = Vector3.ZERO
	#collision_point = self.translation.direction_to(body.translation) * (4/self.translation.distance_to(body.translation))
	
	#body.velocity += explode_force*get_global_transform().origin.direction_to(body.get_global_transform().origin)#collision_point * *15 #body.global_transform.origin,collision_point*10)
	#body.wish_jump = true
	body.velocity += explode_force*get_global_transform().origin.direction_to(body.get_global_transform().origin) * 4/self.translation.distance_to(body.translation)
	body.vertical_velocity += explode_force*get_global_transform().origin.direction_to(body.get_global_transform().origin).length()

	print (explode_force*get_global_transform().origin.direction_to(body.get_global_transform().origin))
	#print(3/self.translation.distance_to(body.translation))



