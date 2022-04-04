extends Spatial



var decal:bool = true

func _on_Timer_timeout():
	queue_free()

func _ready():
	$Explosion.play()
	$Explosion2.play()
	$AnimatedSprite3D.play("Explosion")
	$MeshInstance.visible = decal
