extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("network_peer_connected",$Network_ui,"player_connected")
	get_tree().connect("connected_to_server",$Network_ui,"join_lobby")


func _player_disconnected(id):
	pass
