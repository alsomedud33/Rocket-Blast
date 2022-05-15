extends Node

func emit_res_change(value):
	resolution = value

onready var resolution:Vector2 setget emit_res_change
var res_sel:int #= 0
var vsync:bool
var fullscreen = false
var fullscreen_sel: int# = 0
var show_fps = false

var mouse_sense:float# = 50
var viewmodel_fov = 90
var fov = 75


var complete = false

var sticky_deployed:int = 0
var player: int
var Paused = false



var file_name = "user://keybinding.json"

var key_dict = {
	"move_forward":65,
	"move_back":83,
	"move_right":68,
	"move_left":65,
	"jump":32,
	"shoot1":1,
	"shoot2":2,
	"wep_slot_1":49,
	"wep_slot_2":50,
	"wep_slot_3":51,
	"wep_slot_4":52,
	"wep_slot_5":53,
	"wep_slot_6":54,
	"wep_slot_7":55,
	"wep_slot_8":56,
	"wep_slot_9":57,
	"Wep_scroll+":4,
	"Wep_scroll-":5,
	}
				
var setting_key = false

#We'll use this when the game loads
func load_keys():
	var file = File.new()
	if(file.file_exists(file_name)):
		delete_old_keys()
		file.open(file_name,File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if(typeof(data) == TYPE_DICTIONARY):
			key_dict = data
			setup_keys()
		else:
			printerr("corrupted data!")
	else:
		#NoFile, so lets save the default keys now
		save_keys()
	pass
	
func delete_old_keys():
	#Remove the old keys
	for i in key_dict:
		var oldkey = InputEventKey.new()
		oldkey.scancode = int(Globals.key_dict[i])
		InputMap.action_erase_event(i,oldkey)

func setup_keys():
	for i in key_dict:
		for j in get_tree().get_nodes_in_group("button_keys"):
			if(j.action_name == i):
				if key_dict[i] == 1 or key_dict[i] == 2 or key_dict[i] == 4 or key_dict[i] ==5:
					print (key_dict[i])
					j.text = index_to_text(key_dict[i])
				else:
					j.text = OS.get_scancode_string(key_dict[i])
		var newkey = InputEventKey.new()
		newkey.scancode = int(key_dict[i])
		InputMap.action_add_event(i,newkey)

func index_to_text(index:int):
	var text:String
	match index:
			1:
				text = "Mouse 1"
			2:
				text = "Mouse 2"
			3:
				text = "BUTTON_MIDDLE"
			4:
				text = "MWHEELUP"
			5:
				text = "MWHEELDOWN"
			8:
				text = "SIDE_BTN_1"
			9:
				text = "SIDE_BTN_2"
	return text

func save_keys():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(key_dict))
	file.close()
	print("saved")
	pass

var save_path = SAVE_DIR +"save.dat"

const SAVE_DIR = "user://saves/"

onready var settings = {
	"username" : str(Players.username),
	"mouse_sense" : mouse_sense,
	"viewmodel_fov" : viewmodel_fov,
	"fov" : fov,
	
	"master_vol" : AudioServer.get_bus_volume_db(0),
	"effects_vol" : AudioServer.get_bus_volume_db(1),
	"music_vol" : AudioServer.get_bus_volume_db(2),
	
	"res_sel" : res_sel,
	"resolution" : resolution,
	"fullscreen" : fullscreen,
	"fullscreen_sel" : fullscreen_sel,
	"vsync" : vsync,
	"show_fps" : show_fps,
}

func save_data():
	settings = {
	"username" : str(Players.username),
	"mouse_sense" : mouse_sense,
	"viewmodel_fov" : viewmodel_fov,
	"fov" : fov,
	
	"master_vol" : AudioServer.get_bus_volume_db(0),
	"effects_vol" : AudioServer.get_bus_volume_db(1),
	"music_vol" : AudioServer.get_bus_volume_db(2),
	
	"res_sel" : res_sel,
	"resolution" : resolution,
	"fullscreen" : fullscreen,
	"fullscreen_sel" : fullscreen_sel,
	"vsync" : vsync,
	"show_fps" : show_fps,
	}
	
	var dir = Directory.new()
	
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path,File.WRITE)
	if error == OK:
		file.store_var(settings)
		file.close()

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var player_data = file.get_var()
			return player_data
			file.close()
	else:
		settings = {
			"username" : str(Players.username),
			"mouse_sense" : 2.5,
			"viewmodel_fov" : 90,
			"fov" : 90,
			
			"master_vol" : AudioServer.get_bus_volume_db(0),
			"effects_vol" : AudioServer.get_bus_volume_db(1),
			"music_vol" : AudioServer.get_bus_volume_db(2),
			
			"res_sel" : res_sel,
			"resolution" : resolution,
			"fullscreen" : fullscreen,
			"fullscreen_sel" : fullscreen_sel,
			"vsync" : vsync,
			"show_fps" : show_fps,
		}
		save_data()
		load_data()
		
		

#var map_1 = preload("res://Maps/Map_1.tscn")
#var map_2 = preload("res://Maps/Map_2.tscn")

#onready var first_area = preload("res://Maps/Map 1/First Area.tscn")
#onready var second_area = preload("res://Maps/Map 1/First Area B.tscn")
#onready var third_area = preload("res://Maps/Map 1/Second Area.tscn")
#onready var fourth_area = preload("res://Maps/Map 1/Third Area.tscn")
#onready var fith_area = preload("res://Maps/Map 1/Fourth Area.tscn")
#onready var sixth_area = preload("res://Maps/Map 1/Jurf Walls.tscn")
#
#onready var explosion_hitbox = preload("res://assets/Soldier/Explosion_Hitbox.tscn")
#onready var partical = preload("res://assets/Sfx/Explosion.tscn")
#onready var decal = preload("res://assets/Textures/Bullet Decal.tscn")
#onready var rocket = preload("res://assets/Soldier/Rocket.tscn")
#onready var sticky = preload("res://assets/Demoman/Sticky Bomb.tscn")
#
#onready var soldier = preload("res://assets/Soldier/Soldier.tscn")
#onready var demo = preload("res://assets/Demoman/Demolition Man.tscn")
#
#onready var text_3d = preload("res://assets/Platform Objects/3DText.tscn")

var proj_counter = 0


signal instance_player(id)


onready var game_data = settings

func _ready():
	load_data()
	load_keys()
	#AudioServer.set_bus_volume_db(0, linear2db(0.5))

func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
	if complete == true:
		yield(get_tree().create_timer(.001), "timeout")
		proj_counter = 0
		complete = false
