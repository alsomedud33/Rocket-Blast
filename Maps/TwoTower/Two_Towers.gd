extends Node


var soldier = preload("res://assets/Soldier/Online/Soldier(online).tscn")
func _on_Skybox_Area_body_exited(body):
	body.global_transform.origin = $"Skybox_Area/Respawn".global_transform.origin


# Called when the node enters the scene tree for the first time.
func _ready():
	Transitions.fade_out()
	Players.set_ids()
	_instance_players()
	
	print("signals connected")
#	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
#	get_tree().connect("network_peer_connected",self,"_player_joined")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	Network.connect("winner",self,"restart")
	Network.connect("instance_player",self,"_instance_player")
	Network.connect("player_shot",self,"_player_shot")
	Network.connect("destroy_rocket",self,"_destroy_rocket")
	Network.connect("rocket_hit",self,"_rocket_hit")
	Network.connect("explosion_hitbox",self,"_explosion_hitbox")
	Network.connect("respawn",self,"_respawn")
	Network.connect("koth_point_entered",self,"_koth_point_entered")
	Network.connect("koth_point_exited",self,"_koth_point_exited")
	Network.connect("koth_points_change",self,"_koth_points_change")
	#restart(1)

#func _player_joined(id):
#	rpc_id(1,"team_info_request")
#	print(str(id) + " connected")
#	print (str(get_tree().get_network_connected_peers()) + " are in the game")
#	_instance_player(id,Network.team_index % 2+1)
#	pass
#
#func _player_disconnected(id):
#	if NetNodes.players.has_node(str(id)):
#		NetNodes.players.get_node(str(id)).queue_free()
#	pass
func _player_disconnected(id):
	var player = NetNodes.players.get_node(str(id))
	NetNodes.players.remove_child(player)
	player.queue_free()
	print ("player with id: " +str(id) +" has disconnected")
	for p in NetNodes.players.get_children():
			p.visible = true
			print (p.name + "'s visibiliy is " + String(p.visible))

func _server_disconnected():
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	for p in NetNodes.players.get_children():
		p.queue_free()
	SceneChanger.goto_scene("res://Online/Lobby/Lobby.tscn",self)
	
func restart(num):
	rpc("restart_game")
#	restart_game()

remotesync func restart_game():
	for p in NetNodes.players.get_children():
		NetNodes.players.remove_child(p)
		p.queue_free()
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	get_tree().set_network_peer(null)
	Players.player_list.clear()
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://Online/Lobby/Lobby.tscn",self)
	

func _instance_players():
	for id in Players.id_list:
		_instance_player(id,Players.player_list[id]["team"])
	_instance_player(Players.net_id,Players.player_info["team"])

func _instance_player(id,_team):
	print("creating player " +str(id))
	var p = soldier.instance()
	p.set_network_master(id)
	p.name = str(id)
	p.team = _team
	p.global_transform.origin = get_node("Spawn Points/" +str(p.team)+"/"+"Spawn Point"+str(p.team)).global_transform.origin
	NetNodes.players.add_child(p)

func _respawn(id,merc,team):
	rpc("_respawn_remote",id,merc,team)
	get_node("CameraHub/Camera").current = true
	var child = NetNodes.players.get_node(str(id))
	NetNodes.players.remove_child(NetNodes.players.get_node(str(id)))#get_node(str(id)).queue_free()
	child.queue_free()
	for p in NetNodes.players.get_children():
		p.visible = true
#	yield(get_tree().create_timer(2),"timeout")
	print("respawning player: " +str(id))
	var p = soldier.instance()
	p.set_network_master(id)
	p.name = str(id)
	p.team = team
	p.global_transform.origin = get_node("Spawn Points/" +str(p.team)+"/"+"Spawn Point"+str(p.team)).global_transform.origin
	get_node("CameraHub/Camera").current = false
	NetNodes.players.add_child(p)
#	NetNodes.players.get_node(str(id)).queue_free()
##	yield(get_tree().create_timer(2),"timeout")
#	print("respawning player: " +str(id))
#	var p = soldier.instance()
#	p.set_network_master(id)
#	p.name = str(id)
#	p.team = team
#	p.global_transform.origin = get_node("Spawn Points/" +str(p.team)+"/"+"Spawn Point"+str(p.team)).global_transform.origin
#	NetNodes.players.add_child(p)
#	#p.global_transform.origin = get_node("Spawn Points/" +str(p.team)+"/"+"Spawn Point"+str(p.team)).global_transform.origin

remote func _respawn_remote(id,merc,team):
	#NetNodes.players.get_node(str(id)).queue_free()
	var child = NetNodes.players.get_node(str(id))
	NetNodes.players.remove_child(NetNodes.players.get_node(str(id)))#get_node(str(id)).queue_free()
	child.queue_free()
	for p in NetNodes.players.get_children():
		p.visible = true
#	yield(get_tree().create_timer(2),"timeout")
	print("respawning player: " +str(id))
	var p = soldier.instance()
	p.set_network_master(id)
	p.name = str(id)
	p.team = team
	p.global_transform.origin = get_node("Spawn Points/" +str(p.team)+"/"+"Spawn Point"+str(p.team)).global_transform.origin
	NetNodes.players.add_child(p)

func _koth_point_entered(body_name,cap_amount,cap_rate,max_cap):
	rpc("_koth_point_entered_remote",body_name,cap_amount,cap_rate,max_cap)
	if NetNodes.players.get_node(body_name).team == 1:
		Network.cap_rate += 1
	else:# NetNodes.players.get_node(body_name).team == 2:
		Network.cap_rate -= 1

remote func _koth_point_entered_remote(body_name,cap_amount,cap_rate,max_cap):
	print ("Player has entered the point")
	if NetNodes.players.get_node(body_name).team == 1:
		Network.cap_rate += 1
	else:#NetNodes.players.get_node(body_name).team == 2:
		Network.cap_rate -= 1

func _koth_point_exited(body_name,cap_amount,cap_rate,max_cap):
	rpc("_koth_point_exited_remote",body_name,cap_amount,cap_rate,max_cap)
	if NetNodes.players.get_node(body_name).team == 1:
		Network.cap_rate -= 1
	else:# NetNodes.players.get_node(body_name).team == 2:
		Network.cap_rate += 1

remote func _koth_point_exited_remote(body_name,cap_amount,cap_rate,max_cap):
	print ("Player has exited the point")
	if NetNodes.players.get_node(body_name).team == 1:
		Network.cap_rate -= 1
	else:# NetNodes.players.get_node(body_name).team == 2:
		Network.cap_rate += 1

func _koth_points_change(cap_rate):
	rpc("_koth_points_change_remote",cap_rate)
	Network.cap_amount += Network.cap_rate
	Network.cap_amount = clamp(Network.cap_amount,-Network.max_cap,Network.max_cap)
	if Network.cap_amount == Network.max_cap:
		Network.red_captured = true
		Network.blue_captured = false
	elif Network.cap_amount == -Network.max_cap:
		Network.blue_captured = true
		Network.red_captured = false
	print ("Cap amount is: "+ str(Network.cap_amount))

remote func _koth_points_change_remote(cap_rate):
	Network.cap_amount += Network.cap_rate
	Network.cap_amount = clamp(Network.cap_amount,-Network.max_cap,Network.max_cap)
	if Network.cap_amount == Network.max_cap:
		Network.red_captured = true
		Network.blue_captured = false
	elif Network.cap_amount == -Network.max_cap:
		Network.blue_captured = true
		Network.red_captured = false


func _player_shot(id,position,wep_type):
	randomize()
	rpc("_player_shot_remote", id,position,wep_type)
	match wep_type:
		"Rocket":
			var r = Network.rocket.instance()
			r.real = true
			if NetNodes.players.get_node(str(id)).raycast.is_colliding():
				r.look_at_from_position(NetNodes.players.get_node(str(id)).guns.global_transform.origin,NetNodes.players.get_node(str(id)).raycast.get_collision_point(), Vector3.UP)
			else:
				r.global_transform.origin = NetNodes.players.get_node(str(id)).guns.global_transform.origin
				r.rotation_degrees = Vector3(-NetNodes.players.get_node(str(id)).head.rotation_degrees.x+0.5, NetNodes.players.get_node(str(id)).rotation_degrees.y+181,0)
			r.velocity = r.transform.basis.z * -r.speed
			
			r.rocket_owner = NetNodes.players.get_node(str(id)).name
			r.name = NetNodes.players.get_node(str(id)).name + str(NetNodes.players.get_node(str(id)).rocket_num)
			NetNodes.players.get_node(str(id)).rocket_num += 1
			NetNodes.rockets.add_child(r)
		"Hitscan":
			var collision_point:Vector3
			var total_damage = 0
			var dmg = 6
			var hit = false
			for r in NetNodes.players.get_node(id).camera.get_node("RayContainer").get_children():
				r.cast_to.x = rand_range(-NetNodes.players.get_node(str(id)).wep_spread, NetNodes.players.get_node(str(id)).wep_spread)
				r.cast_to.y = rand_range(-NetNodes.players.get_node(str(id)).wep_spread, NetNodes.players.get_node(str(id)).wep_spread)
				if r.is_colliding() and r.get_collider().is_in_group("Player"):
					hit = true
					print (r.get_collider().name)
					print(NetNodes.players.get_node(id).head.get_global_transform().origin.distance_to(r.get_collision_point()))
					dmg = round(75 * 1/clamp(NetNodes.players.get_node(id).head.get_global_transform().origin.distance_to(r.get_collision_point()),15,25))
					r.get_collider().take_damage(dmg,id,true)
					total_damage+=dmg
					collision_point = r.get_collision_point()
			if id  == str(get_tree().get_network_unique_id()) and hit == true:
				Network.emit_signal("hit",total_damage,collision_point)
		"Melee":
			var hit = false
			var collision_point:Vector3
			for hb in NetNodes.players.get_node(str(id)).camera.get_node("Melee Hitbox").get_overlapping_areas():
				if hb.get_parent().is_in_group("Player") and hb.get_parent().name != id and hit == false:
					hb.get_parent().take_damage(65,id,true)
					collision_point = hb.get_parent().head.get_global_transform().origin
					hit = true
			if id  == str(get_tree().get_network_unique_id()) and hit == true:
				Network.emit_signal("hit",65,collision_point)
remote func _player_shot_remote(id, position,wep_type):
	match wep_type:
		"Rocket":
			var r = Network.rocket.instance()
			r.real = false
			if NetNodes.players.get_node(str(id)).raycast.is_colliding():# and NetNodes.players.get_node(str(id)).global_transform.origin.distance_to(NetNodes.players.get_node(str(id)).raycast.get_collision_point()) >3.81:
				r.look_at_from_position(NetNodes.players.get_node(str(id)).guns.global_transform.origin,NetNodes.players.get_node(str(id)).raycast.get_collision_point(), Vector3.UP)
			else:
				r.global_transform.origin = NetNodes.players.get_node(str(id)).guns.global_transform.origin
				r.rotation_degrees = Vector3(-NetNodes.players.get_node(str(id)).head.rotation_degrees.x+0.5, NetNodes.players.get_node(str(id)).rotation_degrees.y+181,0)
			r.velocity = r.transform.basis.z * -r.speed
			r.rocket_owner = NetNodes.players.get_node(str(id)).name
			r.name = NetNodes.players.get_node(str(id)).name + str(NetNodes.players.get_node(str(id)).rocket_num)
			NetNodes.players.get_node(str(id)).rocket_num += 1
			NetNodes.players.get_node(str(id)).get_node("Rocket_Launch").play()
			NetNodes.players.get_node(str(id)).get_node("Rocket_Trail").play()
			NetNodes.rockets.add_child(r)
		"Hitscan":
			pass
#			for r in NetNodes.players.get_node(str(id)).camera.get_node("RayContainer").get_children():
#				r.cast_to.x = rand_range(NetNodes.players.get_node(str(id)).wep_spread, -NetNodes.players.get_node(str(id)).wep_spread)
#				r.cast_to.y = rand_range(NetNodes.players.get_node(str(id)).wep_spread, -NetNodes.players.get_node(str(id)).wep_spread)
##				if r.is_colliding() and r.get_collider().is_in_group("Player"):
##					#print (r.get_collider().name)
##					#r.get_collider().take_damage(5,id)
##					if id  == str(get_tree().get_network_unique_id()):
##						Network.emit_signal("hit",5,NetNodes.players.get_node(r.collider().name).global_transform.origin)
func _rocket_hit(rocket, damage):
	rpc ("_rocket_hit_remote",rocket, damage,NetNodes.rockets.get_node(rocket).global_transform.origin)
	if NetNodes.rockets.has_node(rocket):
		for index in NetNodes.rockets.get_node(rocket).get_slide_count():
			if index == 0 and NetNodes.rockets.get_node(rocket).get_slide_collision(index).get_collider().name !=NetNodes.rockets.get_node(rocket).rocket_owner:
					var collision = NetNodes.rockets.get_node(rocket).get_slide_collision(index)
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
					explosion_instance.global_transform.origin = collision.get_position()
					Network.emit_signal("destroy_rocket",rocket)




remote func _rocket_hit_remote(rocket, damage,origin):
	if NetNodes.rockets.has_node(rocket):
		NetNodes.rockets.get_node(rocket).global_transform.origin = lerp(NetNodes.rockets.get_node(rocket).global_transform.origin,origin,0.1)
		for index in NetNodes.rockets.get_node(rocket).get_slide_count():
			#print (get_slide_collision(index).get_collider().name)
			if index == 0 and NetNodes.rockets.get_node(rocket).get_slide_collision(index).get_collider().name !=NetNodes.rockets.get_node(rocket).rocket_owner:
					var collision = NetNodes.rockets.get_node(rocket).get_slide_collision(index)
					var explosion_instance = Network.explosion.instance()
					
#					var decal_instance = Network.decal.instance()
#					decal_instance.name = rocket
#					NetNodes.hitboxes.add_child(decal_instance)
#					decal_instance.global_transform.origin = collision.get_position()
#					decal_instance.look_at(collision.get_position() + collision.get_normal() , Vector3.UP)

					explosion_instance.name = rocket
					explosion_instance.real = NetNodes.rockets.get_node(rocket).real#true#false
					
					NetNodes.hitboxes.add_child(explosion_instance)
					explosion_instance.distance_ratio = 3
					explosion_instance.y_explode_ratio = 1
					explosion_instance.radius_val = 1
					explosion_instance.explode_force = 5
					explosion_instance.global_transform.origin = collision.get_position()
					Network.emit_signal("destroy_rocket",rocket)




func _destroy_rocket(rocket):
	rpc ("_destroy_rocket_remote",rocket)
#	if NetNodes.rockets.has_node(rocket):
#		NetNodes.rockets.get_node(rocket).queue_free()
#		print (rocket + " has been destroyed")

remotesync  func _destroy_rocket_remote(rocket): 
	if NetNodes.rockets.has_node(rocket):
		NetNodes.rockets.get_node(rocket).queue_free()
		print (rocket + " has been destroyed")


func _explosion_hitbox(hitbox,players,damage):
	rpc_unreliable("_explosion_hitbox_remote",hitbox,players,NetNodes.hitboxes.get_node(hitbox).explosion_owner,round(damage * clamp(1/NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.distance_to(NetNodes.players.get_node(players).get_global_transform().origin),0.8,1)),NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin,NetNodes.hitboxes.get_node(hitbox).explode_force,NetNodes.hitboxes.get_node(hitbox).y_explode_ratio,NetNodes.hitboxes.get_node(hitbox).distance_ratio,NetNodes.hitboxes.get_node(hitbox).translation)
	if (NetNodes.hitboxes.get_node(hitbox).explosion_owner == str(get_tree().get_network_unique_id())) and NetNodes.hitboxes.get_node(hitbox).explosion_owner != players:
		Network.emit_signal("hit",round(damage * 1/clamp(NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.distance_to(NetNodes.players.get_node(players).get_global_transform().origin),0.8,1)),NetNodes.players.get_node(players).head.global_transform.origin)
	print ("damage is:" + str(round(damage * 1/clamp(NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.distance_to(NetNodes.players.get_node(players).get_global_transform().origin),0.8,1))))
	NetNodes.players.get_node(players).take_damage(round(damage *1/clamp(NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.distance_to(NetNodes.players.get_node(players).get_global_transform().origin),0.8,1)),NetNodes.hitboxes.get_node(hitbox).explosion_owner)
	NetNodes.players.get_node(players).snap = Vector3.ZERO
	if NetNodes.players.get_node(players).is_on_floor() and NetNodes.hitboxes.get_node(hitbox).explosion_owner != players:
		NetNodes.players.get_node(players).rocket_impulse = 1.5*NetNodes.hitboxes.get_node(hitbox).explode_force*NetNodes.hitboxes.get_node(hitbox).y_explode_ratio*2*NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin).y
		NetNodes.players.get_node(players).rocket_jump = true
	#print("distance from center is: " + str(clamp(NetNodes.hitboxes.get_node(hitbox).translation.distance_to(NetNodes.players.get_node(players).translation),0,2)))
	print(str(NetNodes.hitboxes.get_node(hitbox).explode_force*NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin) * NetNodes.hitboxes.get_node(hitbox).distance_ratio/clamp(NetNodes.hitboxes.get_node(hitbox).translation.distance_to(NetNodes.players.get_node(players).translation),1.3,3)))
	if NetNodes.hitboxes.get_node(hitbox).explosion_owner != players:
		NetNodes.players.get_node(players).velocity += NetNodes.hitboxes.get_node(hitbox).explode_force*NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin) * NetNodes.hitboxes.get_node(hitbox).distance_ratio/clamp(NetNodes.hitboxes.get_node(hitbox).translation.distance_to(NetNodes.players.get_node(players).translation),0,2)
	else:
		NetNodes.players.get_node(players).velocity += NetNodes.hitboxes.get_node(hitbox).explode_force*NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin) * NetNodes.hitboxes.get_node(hitbox).distance_ratio/clamp(NetNodes.hitboxes.get_node(hitbox).translation.distance_to(NetNodes.players.get_node(players).translation),1.3,3)
	NetNodes.players.get_node(players).velocity.y += NetNodes.hitboxes.get_node(hitbox).explode_force*NetNodes.hitboxes.get_node(hitbox).y_explode_ratio*NetNodes.hitboxes.get_node(hitbox).get_global_transform().origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin).y
	print("real")

remote func _explosion_hitbox_remote(hitbox,players,explosion_owner,damage,origin,explode_force,y_explode_ratio,distance_ratio,translation):
	if NetNodes.hitboxes.has_node(hitbox):
		if (explosion_owner == str(get_tree().get_network_unique_id())) and explosion_owner != players:
			Network.emit_signal("hit",damage,NetNodes.players.get_node(players).head.global_transform.origin)
	#NetNodes.players.get_node(players).take_damage(damage)
	NetNodes.players.get_node(players).snap = Vector3.ZERO
	if NetNodes.players.get_node(players).is_on_floor() and explosion_owner != players:
		NetNodes.players.get_node(players).rocket_impulse = 1.5*explode_force*y_explode_ratio*2*origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin).y
		NetNodes.players.get_node(players).rocket_jump = true
	if explosion_owner != players:
		NetNodes.players.get_node(players).velocity += explode_force*origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin) * distance_ratio/clamp(translation.distance_to(NetNodes.players.get_node(players).translation),0,2)
	else:
		NetNodes.players.get_node(players).velocity += explode_force*origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin) * distance_ratio/clamp(translation.distance_to(NetNodes.players.get_node(players).translation),1.3,3)
	NetNodes.players.get_node(players).velocity.y += explode_force*y_explode_ratio*origin.direction_to(NetNodes.players.get_node(players).get_global_transform().origin).y
	print("fake")

