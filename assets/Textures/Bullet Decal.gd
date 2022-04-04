extends Spatial




func _on_Timer_timeout():
	queue_free()

func _ready():
	$Explosion.play()
	$Explosion2.play()
	$AnimatedSprite3D.play("Explosion")
