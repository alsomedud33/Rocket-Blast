extends Node


var mouse_sense = 50
var complete = false

var sticky_deployed:int = 0
var player: int
var Paused = false

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



func _ready():
	AudioServer.set_bus_volume_db(0, linear2db(0.5))

func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
	if complete == true:
		yield(get_tree().create_timer(.001), "timeout")
		proj_counter = 0
		complete = false

