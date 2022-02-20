extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print ("Hello and welcome!!!\n")
	print ("The controls are: ")
	print (" Movement: WASD \n Mouse: Aim \n Left Click: Shoot \n Good Luck!")


func _input(event):
	if event.is_action_pressed("ui_accept"):
			OS.set_window_fullscreen(true) 
	if event.is_action_pressed("ui_cancel"):
		OS.set_window_fullscreen(false) 


