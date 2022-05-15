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
	#AudioServer.set_bus_volume_db(0, linear2db(0.5))

func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
	if complete == true:
		yield(get_tree().create_timer(.001), "timeout")
		proj_counter = 0
		complete = false
