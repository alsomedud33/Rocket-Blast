extends Node

const DEFAULT_PORT = 28700
const MAX_CLIENTS = 18

var server = null
var client = null

var ip_address = "127.0.0.1"

var team_index=0

signal instance_player(id,team)
signal player_shot(id,location)
signal destroy_rocket(rocket)
signal rocket_hit(rocket, damage)
signal explosion_hitbox(hitbox,players,damage)
signal hit(dmg,location)
signal respawn(id,merc,team)

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

func create_server():
	print("starting server")
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT,MAX_CLIENTS)
	get_tree().set_network_peer(server)

func join_server():
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address,DEFAULT_PORT)
	get_tree().set_network_peer(client)

func _connected_to_server():
	print("connected to server!")

func _server_disconnected():
	print("disconnected from server!")

func _player_joined(id):
	print("player " +str(id) + " connected")

func _connection_failed():
	print("connected failed")


