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


func _on_BoundingBox_body_exited(body):
	body.global_transform.origin = $Respawn.global_transform.origin



func _on_BoundingBox_body_entered(body):
	body.global_transform.origin = $Respawn.global_transform.origin





func Rocket_Entered(body):
	self.rotation_degrees.x = -90
	body.global_transform.origin = $Respawn.global_transform.origin
	body.rotation_degrees.x = -90


func Level_5(body):
	body.global_transform.origin = $Respawn.global_transform.origin
	body.velocity = Vector3.ZERO
