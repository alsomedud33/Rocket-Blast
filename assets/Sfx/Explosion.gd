extends Spatial


# Declare member variables here. Examples:
# var a = 2
var duration = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(duration)
	$Explosion.play()

func _on_Timer_timeout():
	queue_free()
