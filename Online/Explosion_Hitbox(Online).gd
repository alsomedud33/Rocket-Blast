extends Area

export var duration = 0.6
var velocity = Vector3()
var bounce_normal = Vector3()
export var distance_ratio: float = 3
export var y_explode_ratio: float =3
onready var radius = $CollisionShape.shape.radius
export var radius_val= 1

var newbox = SphereShape.new()
var real = false
var explosion_owner = ""


#var partical = preload("res://assets/Sfx/Explosion.tscn")
#export (PackedScene) onready var partical

#onready var partical_instance = partical.instance()

onready var main = get_tree().current_scene

export var explode_force = 5
var collision_point
# Called when the node enters the scene tree for the first time.
func _ready():
	newbox.radius = radius_val
	$CollisionShape.shape = newbox
	$Timer.start(duration)
	#main.add_child(partical_instance)
	#print (self.global_transform.origin)
	#partical_instance.global_translate(self.translation) 
	#partical_instance.scale = Vector3(0.01,0.01,0.01)
#	radius = radius_val

func _process(delta):
	#partical_instance.global_transform.origin = self.global_transform.origin
	radius = radius_val
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
	if real == true:
		for p in get_overlapping_bodies():
			Network.emit_signal("explosion_hitbox",name,p.name,0)
#	print('hit')
#	body.snap = Vector3.ZERO
#	if body.is_on_floor():
#		body.rocket_impulse = explode_force*y_explode_ratio*2*get_global_transform().origin.direction_to(body.get_global_transform().origin).y
#		body.rocket_jump = true
#	body.velocity += explode_force*get_global_transform().origin.direction_to(body.get_global_transform().origin) * distance_ratio/self.translation.distance_to(body.translation)
#	body.velocity.y += explode_force*y_explode_ratio*get_global_transform().origin.direction_to(body.get_global_transform().origin).y

