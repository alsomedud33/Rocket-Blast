extends Control


var Paused = false
var fullscreen = false

func _ready():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
				print ("ui_cancel")
				Paused = false
			false:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
				Physics2DServer.set_active(true)
				visible = true
				print ("ui_cancel")
				Paused = true


func _on_HScrollBar_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value*2))
	$"Panel/Volume Percent".text = "%d%%" % (value * 100)

func _on_Mouse_Sense_value_changed(value):
	Globals.mouse_sense = value*20
	$"Panel/Sense Value".text = "%3.2f" % value



