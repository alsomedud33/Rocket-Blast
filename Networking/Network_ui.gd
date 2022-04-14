extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LineEdit.text = "127.0.0.1"
	Transitions.fade_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Create_button_pressed():
	Network.create_server()
	hide()
	Network.emit_signal("instance_player",get_tree().get_network_unique_id(), Network.team_index % 2+1)
	print(str(get_tree().get_network_unique_id()) + " started server")

func _on_Join_button_pressed():
	hide()
	Network.join_server()
	yield(get_tree().create_timer(1),"timeout")
	rpc_id(1,"team_info_request")
	yield(get_tree().create_timer(1),"timeout")
	Network.emit_signal("instance_player",get_tree().get_network_unique_id(), Network.team_index % 2+1)
	print(str(get_tree().get_network_unique_id()) + " joined server")

func _on_Exit_button_pressed():
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	get_tree().quit()


func _on_LineEdit_text_changed(new_text):
	Network.ip_address = new_text


func _on_Back_pressed():
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",get_parent())

remote func team_info_request():
	Network.team_index +=1
	var id = get_tree().get_rpc_sender_id()
	print ("request from", id, "sending " + str(Network.team_index))
	rpc_id(id,"set_team", Network.team_index %2)

remote func set_team(team):
	print ("team_index set to " + str(team))
	Network.team_index = team
