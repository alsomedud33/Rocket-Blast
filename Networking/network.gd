extends Node

const DEFAULT_PORT = 28700
const MAX_CLIENTS = 18

var network_timer
var tick_rate = 0.015

var server = null
var client = null
var connection = null

var ip_address = "127.0.0.1"

var team_index=0

var cap_rate:int = 0
var cap_amount = 0
var max_cap = 50


var time_limit_mins = 3
var time_limit_sec = 0



var red_time_limit_mins = time_limit_mins
var red_time_limit_sec = time_limit_sec

var blue_time_limit_mins = time_limit_mins
var blue_time_limit_sec = time_limit_sec

var red_captured:bool = false
var blue_captured:bool = false


signal winner(team)
signal instance_player(id,team)
signal player_shot(id,location)
signal destroy_rocket(rocket)
signal rocket_hit(rocket, damage)
signal explosion_hitbox(hitbox,players,damage)
signal hit(dmg,location)
signal respawn(id,merc,team)
signal koth_point_entered(body_name,cap_amount,cap_rate,max_cap)
signal koth_point_exited(body_name,cap_amount,cap_rate,max_cap)
signal koth_points_change(cap_rate)


var rocket_launcher = preload("res://assets/Soldier/Rocket Launcher.tscn")
var soldier = preload("res://assets/Soldier/Online/Soldier(online).tscn")
var rocket = preload ("res://assets/Soldier/Online/Rocket(online).tscn")
var explosion = preload("res://Online/Explosion_Hitbox(online).tscn")
var decal = preload('res://assets/Textures/Bullet Decal.tscn')
var health_pack = preload('res://Online/Health Pack/Health Pack Box.tscn')

func _ready():
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	get_tree().connect("network_peer_connected",self,"_player_joined")
	get_tree().connect("connection_failed",self,"_connection_failed")
	connect("koth_points_change",self,"_update_timer")



func _update_timer(cap_rate):
	rpc("_update_timer_remote",cap_rate)

remotesync func _update_timer_remote(cap_rate):
	if red_captured == true:
		if red_time_limit_sec == 0 and red_time_limit_mins == 0:
			red_time_limit_sec =0
			red_time_limit_mins =0
			emit_signal("winner",1)
		elif red_time_limit_sec <= 0:
			red_time_limit_mins -= 1
			red_time_limit_sec = 59
		else:
			red_time_limit_sec -= 1
	elif blue_captured == true:
		if blue_time_limit_sec == 0 and blue_time_limit_mins == 0:
			blue_time_limit_sec =0
			blue_time_limit_mins =0
			emit_signal("winner",2)
		elif blue_time_limit_sec <= 0:
			blue_time_limit_mins -= 1
			blue_time_limit_sec = 59
		else:
			blue_time_limit_sec -= 1

func create_server():
	network_timer = Timer.new()
	network_timer.name = "Net_Time"
	network_timer.wait_time = tick_rate
	add_child(network_timer)
	network_timer.start()
	print("starting server")
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT,MAX_CLIENTS)
	get_tree().set_network_peer(server)

func join_server():
	network_timer = Timer.new()
	network_timer.name = "Net_Time"
	network_timer.wait_time = tick_rate
	add_child(network_timer)
	network_timer.start()
	client = NetworkedMultiplayerENet.new()
	connection = client.create_client(ip_address,DEFAULT_PORT)
	if connection != OK:
		client.close_connection()
	else:
		get_tree().set_network_peer(client)

func _connected_to_server():
	print("connected to server!")

var server_disconnect = false
func _server_disconnected():
	print("disconnected from server!")
	client.close_connection()
	server_disconnect = true

func _player_joined(id):
	print("player " +str(id) + " connected")

func _connection_failed():
	print("connected failed")


