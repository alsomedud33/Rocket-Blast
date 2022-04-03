extends Spatial




func _on_Timer_timeout():
	queue_free()

func _ready():
	$AnimatedSprite3D.play("Explosion")
