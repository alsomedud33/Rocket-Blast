extends Node


var mouse_sense = 50
var complete = false

var sticky_deployed:int = 0
var player: int


func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
