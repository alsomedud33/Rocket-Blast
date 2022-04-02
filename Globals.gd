extends Node


var mouse_sense = 50
var complete = false

var sticky_deployed:int = 0
var player: int

#var map_1 = preload("res://Maps/Map_1.tscn")
#var map_2 = preload("res://Maps/Map_2.tscn")
onready var explosion_hitbox = preload("res://assets/Soldier/Explosion_Hitbox.tscn")
onready var partical = preload("res://assets/Sfx/Explosion.tscn")
var proj_counter = 0

func _ready():
	AudioServer.set_bus_volume_db(0, linear2db(0.5))

func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
	if complete == true:
		yield(get_tree().create_timer(.001), "timeout")
		proj_counter = 0
		complete = false


