extends Node


var username = ""
var team: int = Network.team_index
var player_count = 1 

var id_list = []
var net_id = 1

var player_info = {}
var player_list = {}


func set_info():
	player_info["username"] = username
	player_info["team"] = team + 1
	player_info["merc"] = "Solly"
	player_list[1] = player_info

func set_ids():
	id_list = get_tree().get_network_connected_peers()
	net_id = get_tree().get_network_unique_id()
