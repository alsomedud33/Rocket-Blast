extends Spatial


export var rotate = 0.01

func _physics_process(delta):
#	if NetNodes.players.has_node("1"):
#		$Camera.look_at(NetNodes.players.get_node("1").global_transform.origin,Vector3.UP)
#	else:
	self.rotate_y(rotate)

