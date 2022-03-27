extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if ParticleCache.loaded:
		set_physics_process(false)
		print ("Hello and welcome!!!\n")
		print ("The controls are: ")
		print (" Movement: WASD \n Mouse: Aim \n Left Click: Shoot \n Good Luck!")

func _process(delta):
	
	if Input.is_action_just_pressed("ui_down"):
		$Soldier.global_transform = $Respwan.global_transform

