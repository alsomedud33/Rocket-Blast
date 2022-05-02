extends Control



var fullscreen = false


onready var masterVol_scroll = $"Panel/Master Volume"
onready var effecctsVol_scroll = $"Panel/Effects Volume"
onready var musicVol_scroll = $"Panel/Music2"
func _ready():
	Transitions.fade_out()
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#AudioServer.set_bus_volume_db(0, linear2db(0.5))
#	masterVol_scroll.value = db2linear(AudioServer.get_bus_volume_db(0))
#	effecctsVol_scroll.value = db2linear(AudioServer.get_bus_volume_db(1))
#	musicVol_scroll.value = db2linear(AudioServer.get_bus_volume_db(2))

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		match fullscreen:
			false:
				OS.set_window_fullscreen(true)
			#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				fullscreen = true
			true:
				OS.set_window_fullscreen(false) 
			#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				fullscreen = false

	if event.is_action_pressed("ui_cancel"):
		match Globals.Paused:
			true:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				get_tree().paused = false
				visible = false
				#print ("ui_cancel")
				Globals.Paused = false
			false:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
				Physics2DServer.set_active(true)
				visible = true
				#print ("ui_cancel")
				Globals.Paused = true


func _on_HScrollBar_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))
	$"Panel/Volume Percent".text = "%d%%" % (value * 100)

func _on_Volume_Scroll2_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))
	$"Panel/Volume Percent2".text = "%d%%" % (value * 100)

func _on_Music2_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear2db(value))
	$"Panel/Volume Percent3".text = "%d%%" % (value * 100)

func _on_Mouse_Sense_value_changed(value):
	Globals.mouse_sense = value*20
	$"Panel/Sense Value".text = "%3.2f" % value





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
#	Transitions.fade_in()
#	MusicController.fade_out()
#	yield(Transitions.anim,"animation_finished")
#	get_tree().quit()
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	if get_tree().current_scene.name == "Two_Towers":
		SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",[get_tree().current_scene, get_node("/root/NetNodes/"+ str(get_tree().get_network_unique_id()))], true)
	else:
		SceneChanger.goto_scene("res://TitleScreen/TitleScreen.tscn",get_parent().get_parent())
	get_tree().paused = false
	visible = false
	Globals.Paused = false


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


func _on_Quit3_pressed():
	$"Settings Popup".popup()
