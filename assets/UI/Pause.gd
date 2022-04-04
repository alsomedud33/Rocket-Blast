extends Control


var Paused = false
var fullscreen = false

onready var volume_scroll = $"Panel/Volume Scroll"
func _ready():
	Transitions.fade_out()
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#AudioServer.set_bus_volume_db(0, linear2db(0.5))
	volume_scroll.value = db2linear(AudioServer.get_bus_volume_db(0))

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
		match Paused:
			true:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				get_tree().paused = false
				visible = false
				#print ("ui_cancel")
				Paused = false
			false:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
				Physics2DServer.set_active(true)
				visible = true
				#print ("ui_cancel")
				Paused = true


func _on_HScrollBar_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))
	$"Panel/Volume Percent".text = "%d%%" % (value * 100)
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
	Paused = false

func _on_Bomber_Man_pressed():
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	SceneChanger.goto_scene("res://Maps/Map_2.tscn",get_tree().get_current_scene())
	#get_tree().change_scene_to(load("res://Maps/Map_2.tscn"))#change_scene("res://Maps/Map_2.tscn")
	get_tree().paused = false
	visible = false
#	print ("ui_cancel")
	Paused = false


func _on_Quit_pressed():
	Transitions.fade_in()
	yield(Transitions.anim,"animation_finished")
	get_tree().quit()
