extends Spatial


export var rotate = 0.01

func _physics_process(delta):
	self.rotate_y(rotate)

