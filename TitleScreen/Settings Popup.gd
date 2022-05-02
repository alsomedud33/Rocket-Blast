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
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.load_data()
	mouse_sens_scroll.value = Globals.load_data().mouse_sense/20
	viewmodel_fov_scroll.value = Globals.load_data().viewmodel_fov
	fov_scroll.value = Globals.load_data().fov
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var game_data = Globals.data

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
