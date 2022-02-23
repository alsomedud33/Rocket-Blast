extends Node


var mouse_sense = 2.5
var complete = false

var sticky_deployed:int = 0

func _process(delta):
	if sticky_deployed < 0:
		sticky_deployed = 0
