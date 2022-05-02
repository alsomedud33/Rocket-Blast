extends Control

signal team_info_sent()

onready var display_txt = $Info_Text
onready var anim = $AnimationPlayer
onready var username_input = $"Settings_panel/Username"

func _ready():
	if Network.server_disconnect == true:
		anim.play("Server Disconnected")
	anim.connect("animation_finished",self,"_server_disconnect_false")
	get_tree().connect("network_peer_disconnected",self,"_remove_client")
	$Game_panel/LineEdit.text = "127.0.0.1"
	Transitions.fade_out()
	username_input.text = Globals.load_data().username#Players.username#Globals.load_data().username

func _server_disconnect_false(anim_name):
	Network.server_disconnect = false

func _remove_client(client_id):
	var panel_id 
	var temp = 0
	for k in Players.player_list.keys():
		temp += 1
		print ("Scrolling through to player: "+ str(k))
		if str(k) == str(get_tree().get_network_unique_id()):
			print (" we have got player position: " + str(k))
			panel_id  = temp
	rpc("_remove_client_remote",panel_id ,client_id)
	Players.player_list.erase(client_id)
	$Players_panel/ItemList.remove_item(panel_id )
	print(Players.player_list)

remote func _remove_client_remote(panel_id ,client_id):
	Players.player_list.erase(client_id)
	$Players_panel/ItemList.remove_item(panel_id )
	print(Players.player_list)


func join_lobby():
	rpc_id(1,"team_info_request")
#	yield(get_tree().create_timer(1),"timeout")
	yield(self,"team_info_sent")
	rpc_id(1,"send_player_info",Players.player_info)
	yield(get_tree().create_timer(.1),"timeout")
	for p in Players.player_list:
		$Players_panel/ItemList.add_item(Players.player_list[p]["username"] + "    team: " + str(Players.player_list[p]["team"]))
	$Players_panel.show()

func player_connected(id):
	print("player id: " + str(id) + " found")
	if get_tree().get_network_connected_peers().size() <= Network.MAX_CLIENTS and get_tree().is_network_server():
		$Start_button.show()

func _on_Create_button_pressed():
	if $Settings_panel/Username.text != "":
		$Settings_panel.hide()
		$"Game_panel/Create_button".disabled = true
		$"Game_panel/Join_button".disabled = true
		
		Players.set_info()
		Network.create_server()
		for p in Players.player_list:
			$Players_panel/ItemList.add_item(Players.player_list[p]["username"] + "    team: " + str(Players.player_list[p]["team"]))
		$Players_panel.show()
#		Network.emit_signal("instance_player",get_tree().get_network_unique_id(), Network.team_index % 2+1)
		print(str(get_tree().get_network_unique_id()) + " started server")
		anim.play("RESET")
	else:
		anim.play("Enter a username")

func _on_Join_button_pressed():
	if $Settings_panel/Username.text != "":
		$Settings_panel.hide()
		$"Game_panel/Create_button".disabled = true
		$"Game_panel/Join_button".disabled = true
		
		Players.set_info()
		Network.join_server()
		anim.play("RESET")
		if Network.connection != OK:
			$Settings_panel.show()
			$"Game_panel/Create_button".disabled = false
			$"Game_panel/Join_button".disabled = false
			anim.play("connection_failed")
		#	display_txt.text = "Couldn't Connect to server"
	else:
		anim.play("Enter a username")
		#display_txt.text = "Enter a username"
		#rpc_id(1,"team_info_request")
#		yield(get_tree().create_timer(1),"timeout")
#		rpc_id(1,"team_info_request")
#		yield(get_tree().create_timer(1),"timeout")
#		Network.emit_signal("instance_player",get_tree().get_network_unique_id(), Network.team_index % 2+1)
#		print(str(get_tree().get_network_unique_id()) + " joined server")

func _on_Exit_button_pressed():
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	get_tree().quit()


func _on_Back_pressed():
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	get_tree().set_network_peer(null)
	Players.player_list.clear()
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",get_parent())


remote func team_info_request():
	Network.team_index +=1
	var id = get_tree().get_rpc_sender_id()
	print ("request from", id, "sending " + str(Network.team_index % 2))
	rpc_id(id,"set_team", Network.team_index % 2)

remote func set_team(team):
	print ("team_index set to " + str(team))
	Network.team_index = team
	Players.team = team
	Players.set_info()
	emit_signal("team_info_sent")


remote func send_player_info(info):
	Players.player_count += 1
	#info["team"] = Players.player_count
	Players.player_list[get_tree().get_rpc_sender_id()] = info
	$Players_panel/ItemList.add_item(Players.player_list[get_tree().get_rpc_sender_id()]["username"] + "    team: " + str(Players.player_list[get_tree().get_rpc_sender_id()]["team"]))
	for p in Players.player_list:
		if p != 1:
			rpc_id(p,"recieve_player_info", Players.player_list)
	print(Players.player_list)

remote func recieve_player_info(list):
	Players.player_list = list
#	Players.team = list[get_tree().get_network_unique_id()]["team"]
	print(Players.player_list)



func _on_LineEdit_text_changed(new_text):
	Network.ip_address = new_text

func _on_Username_text_changed(new_text):
	Players.username = new_text
	Globals.save_data()


func _on_Start_button_pressed():
	$"Start_button".disabled = true
	rpc("start_game")
	start_game()

remote func start_game():
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://Maps/TwoTower/Two_Towers.tscn",get_parent())


func _on_CheckBox_toggled(button_pressed):
	$"Game_panel/LineEdit".secret = button_pressed
