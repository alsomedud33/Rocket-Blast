extends WindowDialog

onready var masterVol_scroll = $"TabContainer/Audio/Panel/Master Volume"
onready var effecctsVol_scroll = $"TabContainer/Audio/Panel/Effects Volume"
onready var musicVol_scroll = $"TabContainer/Audio/Panel/Music2"

onready var mouse_sens_spin = $"TabContainer/Game/Panel2/Mouse Sense2"
onready var viewmodel_fov_spin = $"TabContainer/Game/Panel2/Viewmodel FOV Slider2"
onready var fov_spin = $"TabContainer/Game/Panel2/FOV Slider2"

onready var mouse_sens_scroll = $"TabContainer/Game/Panel2/Mouse Sense"
onready var viewmodel_fov_scroll = $"TabContainer/Game/Panel2/Viewmodel FOV Slider"
onready var fov_scroll = $"TabContainer/Game/Panel2/FOV Slider"

onready var master_vol_text = $"TabContainer/Audio/Panel/Volume Percent"
onready var music_vol_text = $"TabContainer/Audio/Panel/Volume Percent3"
onready var effects_vol_text = $"TabContainer/Audio/Panel/Volume Percent2"

onready var mouse_sens_text = $"TabContainer/Game/Panel2/Sense Value"
onready var viewmodel_fov_text = $"TabContainer/Game/Panel2/Viewmodel FOV Value"
onready var fov_text = $"TabContainer/Game/Panel2/FOV Value"

onready var resolution_btn = $"TabContainer/Video/Panel/MarginContainer/VBoxContainer/HBoxContainer5/ResolutionBtn"
onready var fullscreen_btn = $"TabContainer/Video/Panel/MarginContainer/VBoxContainer/HBoxContainer/DisplayBtn"
onready var vsync_btn = $"TabContainer/Video/Panel/MarginContainer/VBoxContainer/HBoxContainer2/VsyncBtn"
onready var fps_btn = $"TabContainer/Video/Panel/MarginContainer/VBoxContainer/HBoxContainer4/DisplayFpsBtn"
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.load_data()
	Globals.mouse_sense = Globals.load_data().mouse_sense
	mouse_sens_scroll.value = Globals.load_data().mouse_sense/20
	viewmodel_fov_scroll.value = Globals.load_data().viewmodel_fov
	fov_scroll.value = Globals.load_data().fov
	
	masterVol_scroll.value = db2linear(Globals.load_data().master_vol)
	effecctsVol_scroll.value = db2linear(Globals.load_data().effects_vol)
	musicVol_scroll.value = db2linear(Globals.load_data().music_vol)
	
	print (str(Globals.load_data().res_sel))
	resolution_btn._select_int(Globals.load_data().res_sel)
	fullscreen_btn._select_int(Globals.load_data().fullscreen_sel)
	resolution_btn.emit_signal("item_selected",Globals.load_data().res_sel)
	fullscreen_btn.emit_signal("item_selected",Globals.load_data().fullscreen_sel)
	vsync_btn.pressed = Globals.load_data().vsync
	fps_btn.pressed = Globals.load_data().show_fps
	
#	print (OS.is_vsync_enabled())
#	OS.set_window_size(Globals.load_data().resolution)
#	Globals.resolution = Vector2(Globals.load_data().resolution)
##
#	OS.set_window_fullscreen(Globals.load_data().fullscreen)
#
	#OS.vsync_enabled = Globals.load_data().vsync
#
#	Globals.show_fps = Globals.load_data().show_fps

func _on_Mouse_Sense_value_changed(value):
	Globals.mouse_sense = value*20
	mouse_sens_text.text = "%3.2f" % value
	mouse_sens_spin.value = value

func _on_Mouse_Sense2_value_changed(value):
	Globals.mouse_sense = value*20
	mouse_sens_text.text = "%3.2f" % value
	mouse_sens_scroll.value = value
	



func _on_Viewmodel_FOV_Slider_value_changed(value):
	Globals.viewmodel_fov = value
	viewmodel_fov_text.text = str(value)
	viewmodel_fov_spin.value = value

func _on_Viewmodel_FOV_Slider2_value_changed(value):
	Globals.viewmodel_fov = value
	viewmodel_fov_text.text = str(value)
	viewmodel_fov_scroll.value = value



func _on_FOV_Slider_value_changed(value):
	Globals.fov = value
	fov_text.text = str(value)
	fov_spin.value = value

func _on_FOV_Slider2_value_changed(value):
	Globals.fov = value
	fov_text.text = str(value)
	fov_scroll.value = value


func _on_Master_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))
	master_vol_text.text = "%d%%" % (value * 100)


func _on_Effects_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))
	effects_vol_text.text = "%d%%" % (value * 100)

func _on_Music2_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear2db(value))
	music_vol_text.text = "%d%%" % (value * 100)


func _on_Quit2_pressed():
	MusicController.random_song()








func _on_Settings_Popup_popup_hide():
	Globals.save_data()


func _on_DisplayBtn_item_selected(index):
	Globals.fullscreen_sel = index
	match index:
		0:
			OS.set_window_fullscreen(false)
			Globals.fullscreen = false
		1:
			OS.set_window_fullscreen(true)
			Globals.fullscreen = true


func _on_ResolutionBtn_item_selected(index):
	Globals.res_sel = index
	
	match index:
		0:
			OS.set_window_size(Vector2(1280,720))
			Globals.resolution = Vector2(1280,720)
		#	get_node("/root").size = Vector2(1024,546)
			#ProjectSettings.set_setting('display/window/size/width',1024)
			#ProjectSettings.set_setting('display/window/size/height',546)
		1:
			OS.set_window_size(Vector2(1360,768))
			Globals.resolution = Vector2(1360,768)
			#get_node("/root").size = Vector2(1280,720)
#			ProjectSettings.set_setting('display/window/size/width',1280)
#			ProjectSettings.set_setting('display/window/size/height',720)
		2:
			OS.set_window_size(Vector2(1600,900))
			Globals.resolution = Vector2(1600,900)
		#	get_node("/root").size = Vector2(1600,900)
#			ProjectSettings.set_setting('display/window/size/width',1600)
#			ProjectSettings.set_setting('display/window/size/height',900)
		3:
			OS.set_window_size(Vector2(1920,1080))
			Globals.resolution = Vector2(1920,1080)
			#get_node("/root").size = Vector2(1920,1080)
#			ProjectSettings.set_setting('display/window/size/width',1920)
#			ProjectSettings.set_setting('display/window/size/height',1080)


func _on_VsyncBtn_toggled(button_pressed):
	OS.set_use_vsync(button_pressed)
	Globals.vsync = button_pressed



func _on_DisplayFpsBtn_toggled(button_pressed):
	Globals.show_fps = button_pressed


func _on_TextureFilteringBtn_toggled(button_pressed):
	pass # Replace with function body.
