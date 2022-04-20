extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("network_peer_connected",$Network_ui,"player_connected")
	get_tree().connect("connected_to_server",$Network_ui,"join_lobby")
	get_tree().connect("server_disconnected",self,"_server_disconnected")

func _player_disconnected(id):
	pass

func _server_disconnected():
	Players.player_list.clear()
	print ("cleared the player list")
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene('res://Online/Lobby/Lobby.tscn',self)
