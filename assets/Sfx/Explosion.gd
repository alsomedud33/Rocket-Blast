extends Spatial


# Declare member variables here. Examples:
# var a = 2
var duration = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(duration)
	yield(get_tree().create_timer(0.15), "timeout")
	if Globals.player == 1:
		$Explosion.play()
	else:
		
		$Explosion2.play()

func _on_Timer_timeout():
	queue_free()
