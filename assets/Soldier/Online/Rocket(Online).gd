extends KinematicBody

var frame = 0 
var duration = 5
export var speed:int = 10
var velocity = Vector3()
var bounce
var rocket_owner = ""
var real = false
onready var explosion = preload("res://Online/Explosion_Hitbox(online).tscn")#: PackedScene
onready var decal = preload('res://assets/Textures/Bullet Decal.tscn')
onready var main = get_tree().current_scene

#onready var explosion_instance = explosion.instance()


##Networking variables
#var puppet_position = Vector3()
#var puppet_velocity = Vector3()
#var puppet_rotation = Vector3()
#var tick_rate = 0.01
#
#	#when a packet is sent via the network_timer, puppet versions of soldier are updated 
#func _on_network_timer_timeout():
#	if is_network_master() and name == str(get_tree().get_network_unique_id()):
#		rpc_unreliable("update_state", global_transform.origin, velocity, rotation)
#	#only executed on puppet soldiers. Their rotation, position and velocity are adjusted to match where they roughly are
#puppet func update_state(p_pos, p_vel, p_rot):
#	puppet_position = p_pos
#	puppet_velocity = p_vel
#	puppet_rotation = p_rot
#	$Tween.interpolate_property(self,"global_transform",Transform(global_transform.basis,p_pos),tick_rate)
#	$Tween.start()
##Networking end




func _ready():
	Globals.proj_counter += 1
	set_as_toplevel(true)
	$Timer.start(duration)
#	set_collision_mask_bit(1,real)
#	$network_timer.wait_time = tick_rate

remote func update_position(pos,rot):
	global_transform.origin = pos
	rotation = rot
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3.UP,false, 4, PI/4, false)
	bounce = move_and_collide(velocity * delta)
	#if real:
#	Network.emit_signal("rocket_hit",name,0)
#	rpc_unreliable("update_position",global_transform.origin,rotation)
	
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



func _on_Hitbox_body_entered(body):
#	print(is_network_master())
	var rocket = name
#	print (body.name + " owns "+ rocket_owner)
	if body.name !=rocket_owner:
		if real:
			var explosion_instance = Network.explosion.instance()
			
		#					var decal_instance = Network.decal.instance()
		#					decal_instance.name = rocket
		#					NetNodes.hitboxes.add_child(decal_instance)
		#					decal_instance.global_transform.origin = collision.get_position()
		#					decal_instance.look_at(collision.get_position() + collision.get_normal() , Vector3.UP)
			
			explosion_instance.name = rocket
			explosion_instance.real = NetNodes.rockets.get_node(rocket).real#true
			NetNodes.hitboxes.add_child(explosion_instance)
			explosion_instance.distance_ratio = 3
			explosion_instance.y_explode_ratio = 1
			explosion_instance.radius_val = 1
			explosion_instance.explode_force = 5
			explosion_instance.global_transform.origin = global_transform.origin
			Network.emit_signal("destroy_rocket",rocket)
		else:
			if NetNodes.rockets.has_node(rocket):
				NetNodes.rockets.get_node(rocket).queue_free()
