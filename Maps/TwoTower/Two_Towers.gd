extends Node


var soldier = preload("res://assets/Soldier/Online/Soldier(online).tscn")
func _on_Skybox_Area_body_exited(body):
	body.global_transform.origin = $"Skybox_Area/Respawn".global_transform.origin

# Called when the node enters the scene tree for the first time.
func _ready():
	print("signals connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("network_peer_connected",self,"_player_joined")
	Network.connect("instance_player",self,"_instance_player")
	Network.connect("player_shot",self,"_player_shot")
	Network.connect("destroy_rocket",self,"_destroy_rocket")

func _player_joined(id):
	print(str(id) + " connected")
	print (str(get_tree().get_network_connected_peers()) + " are in the game")
	_instance_player(id)
	pass

func _player_disconnected(id):
	if has_node(str(id)):
		get_node(str(id)).queue_free()
	pass

func _instance_player(id):
	print("creating player " +str(id))
	var p = soldier.instance()
	p.set_network_master(id)
	p.name = str(id)
	NetNodes.players.add_child(p)

func _player_shot(id,position):
	rpc("_player_shot_remote", id,position)
	var r = Network.rocket.instance()
	r.real = true
	if NetNodes.players.get_node(str(id)).raycast.is_colliding():
		r.look_at_from_position(NetNodes.players.get_node(str(id)).guns.global_transform.origin,NetNodes.players.get_node(str(id)).raycast.get_collision_point(), Vector3.UP)
	else:
		r.global_transform.origin = NetNodes.players.get_node(str(id)).guns.global_transform.origin
		r.rotation_degrees = Vector3(-NetNodes.players.get_node(str(id)).head.rotation_degrees.x+1, NetNodes.players.get_node(str(id)).rotation_degrees.y+182,0)
	r.velocity = r.transform.basis.z * -r.speed
	
	r.rocket_owner = NetNodes.players.get_node(str(id)).name
	r.name = NetNodes.players.get_node(str(id)).name + str(NetNodes.players.get_node(str(id)).rocket_num)
	NetNodes.players.get_node(str(id)).rocket_num += 1
	NetNodes.rockets.add_child(r)

remote func _player_shot_remote(id, position):
	var r = Network.rocket.instance()
	r.real = false
	if NetNodes.players.get_node(str(id)).raycast.is_colliding():
		r.look_at_from_position(NetNodes.players.get_node(str(id)).guns.global_transform.origin,NetNodes.players.get_node(str(id)).raycast.get_collision_point(), Vector3.UP)
	else:
		r.global_transform.origin = NetNodes.players.get_node(str(id)).guns.global_transform.origin
		r.rotation_degrees = Vector3(-NetNodes.players.get_node(str(id)).head.rotation_degrees.x+1, NetNodes.players.get_node(str(id)).rotation_degrees.y+182,0)
	r.velocity = r.transform.basis.z * -r.speed
	
	r.rocket_owner = NetNodes.players.get_node(str(id)).name
	r.name = NetNodes.players.get_node(str(id)).name + str(NetNodes.players.get_node(str(id)).rocket_num)
	NetNodes.players.get_node(str(id)).rocket_num += 1
	NetNodes.rockets.add_child(r)

func _destroy_rocket(rocket):
	rpc ("_explode_rocket_remote",rocket)
	if NetNodes.rockets.has_node(rocket):
		NetNodes.rockets.get_node(rocket).queue_free()
		print (rocket + " has been destroyed")

remote func _destroy_rocket_remote(rocket):
	if NetNodes.rockets.has_node(rocket):
		NetNodes.rockets.get_node(rocket).queue_free()
		print (rocket + " has been destroyed")



