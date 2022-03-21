extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_BHOP_Check_body_entered(body):
	#yield(get_tree().create_timer(.1), "timeout")
	print (body.wish_jump)
	print (body.name)
	#print (body.wish_jump)
	if body.wish_jump == false:#wish_jump == false:
		print (body.wish_jump)
		body.global_transform.origin = $Respawn.global_transform.origin
		body.velocity = Vector3.ZERO
