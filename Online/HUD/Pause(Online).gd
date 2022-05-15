extends Control



var fullscreen = false
var Paused = false

onready var masterVol_scroll = $"Popup/TabContainer/Audio/Panel/Master Volume"
onready var effecctsVol_scroll = $"Popup/TabContainer/Audio/Panel/Effects Volume"
onready var musicVol_scroll = $"Popup/TabContainer/Audio/Panel/Music2"

onready var master_vol_text = $"Popup/TabContainer/Audio/Panel/Volume Percent"
onready var music_vol_text = $"Popup/TabContainer/Audio/Panel/Volume Percent2"
onready var effects_vol_text = $"Popup/TabContainer/Audio/Panel/Volume Percent3"

onready var mouse_sens_text = $"Popup/TabContainer/Game/Panel2/Sense Value"
onready var viewmodel_fov_text = $"Popup/TabContainer/Game/Panel2/Viewmodel FOV Value"
onready var fov_text = $"Popup/TabContainer/Game/Panel2/FOV Value"

func _ready():
	Transitions.fade_out()
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#AudioServer.set_bus_volume_db(0, linear2db(0.5))
#	masterVol_scroll.value = db2linear(AudioServer.get_bus_volume_db(0))
#	effecctsVol_scroll.value = db2linear(AudioServer.get_bus_volume_db(1))
#	musicVol_scroll.value = db2linear(AudioServer.get_bus_volume_db(2))

func disable_buttons():
	$"Panel/Disconnect".disabled = true
	$"Panel/Quit". disabled = true
	
func _process(delta):
	if self.visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _input(event):
#	if event.is_action_pressed("ui_focus_next"):
#		match fullscreen:
#			false:
#				OS.set_window_fullscreen(true)
#			#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#				fullscreen = true
#			true:
#				OS.set_window_fullscreen(false) 
#			#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#				fullscreen = false

	if event.is_action_pressed("ui_cancel"):
		match Paused:
			true:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#	get_tree().paused = false
				visible = false
				#print ("ui_cancel")
				Paused = false
			false:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#	get_tree().paused = true
				visible = true
				#print ("ui_cancel")
				Paused = true


func _on_HScrollBar_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))
	master_vol_text.text = "%d%%" % (value * 100)

func _on_Volume_Scroll2_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))
	music_vol_text.text = "%d%%" % (value * 100)

func _on_Music2_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear2db(value))
	effects_vol_text.text = "%d%%" % (value * 100)

func _on_Mouse_Sense_value_changed(value):
	Globals.mouse_sense = value*20
	mouse_sens_text.text = "%3.2f" % value

func _on_Viewmodel_FOV_Slider_value_changed(value):
	Globals.viewmodel_fov = value
	viewmodel_fov_text.text = str(value)

func _on_FOV_Slider_value_changed(value):
	Globals.fov = value
	fov_text.text = str(value)

func _on_Rocket_Man_pressed():
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://Maps/Map_1.tscn",get_tree().get_current_scene())
	#get_tree().change_scene_to(load("res://Maps/Map_1.tscn"))
	get_tree().paused = false
	visible = false
#	print ("ui_cancel")
	Globals.Paused = false

func _on_Bomber_Man_pressed():
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://Maps/Map_2.tscn",get_tree().get_current_scene())
	#get_tree().change_scene_to(load("res://Maps/Map_2.tscn"))#change_scene("res://Maps/Map_2.tscn")
	get_tree().paused = false
	visible = false
#	print ("ui_cancel")
	Globals.Paused = false


func _on_Quit_pressed():
	disable_buttons()
	Transitions.fade_in()
	MusicController.fade_out()
	yield(Transitions.anim,"animation_finished")
	get_tree().quit()
#	Transitions.fade_in()
#	yield(Transitions.anim,"animation_finished")
#	if get_tree().current_scene.name == "Two_Towers":
#		SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",get_tree().current_scene)
#	else:
#		SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",get_parent().get_parent().get_parent())
#	get_tree().paused = false
#	visible = false
#	Globals.Paused = false


func _on_Quit2_pressed():
	MusicController.random_song()
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var my_random_number = rng.randi_range(1,2)
#	MusicController.fade_out()
#	#yield(MusicController.tween,"tween_completed")
#	match my_random_number:
#		1:
#			MusicController.play_music(MusicController.military_track)
#			MusicController.fade_in()
#		2:
#			MusicController.play_music(MusicController.jungle_track)
#			MusicController.fade_in()
##		3:
##			MusicController.play_music(MusicController.airport_track)
#			MusicController.fade_in()


func _on_Settings_pressed():
	$"Settings Popup".popup()


func _on_Disconnect_pressed():
	disable_buttons()
	NetNodes.clear_nodes()
	if Network.server != null:
		Network.server.close_connection()
	if Network.client != null:
		Network.client.close_connection()
	get_tree().set_network_peer(null)
	Players.player_list.clear()
	MusicController.fade_out()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",NetNodes.viewport.get_node("Two_Towers"))
	if NetNodes.has_node("HUD (Online)"):
		NetNodes.get_node("HUD (Online)").queue_free()



#	if Network.server != null:
#		Network.server.close_connection()
#	if Network.client != null:
#		Network.client.close_connection()
#	Players.player_list.clear()
#	MusicController.fade_out()
#	Transitions.fade_in()
#	yield(Transitions.anim,"animation_finished")
#	print (get_tree().current_scene.name)
#	SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",get_tree().root.get_node("Two_Towers"))
#	for p in NetNodes.players.get_children():
#		NetNodes.players.remove_child(p)
#		p.queue_free()


func _on_Team_pressed():
	var a = InputEventAction.new()
	a.action = "Change_Team"
	a.pressed = true
	Input.parse_input_event(a)
	#$"../Change_Team".visible = true


func _on_Merc_pressed():
	var a = InputEventAction.new()
	a.action = "Change_Merc"
	a.pressed = true
	Input.parse_input_event(a)


func _on_Resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	get_tree().paused = false
	visible = false
	#print ("ui_cancel")
	Paused = false
