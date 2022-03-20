extends Node


var mouse_sense = 50
var complete = false

var sticky_deployed:int = 0
var player: int

var map_1 = preload("res://Maps/Map_1.tscn")
var map_2 = preload("res://Maps/Map_2.tscn")

var proj_counter = 0

func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
	if complete == true:
		proj_counter = 0
