extends Sprite3D


onready var sprite = self
onready var label = $Label2

func get_camera():
	var r = get_node('/root')
	return r.get_viewport().get_camera()

func position_label(label:Label, point3D:Vector3):
	var camera = get_camera()
	var cam_pos = camera.translation
	var offset = Vector2(label.get_size().x/2, 0)
	label.rect_position = camera.unproject_position(point3D) - offset

func _process(_delta):
	var cam = get_camera()
	var test_point:Vector3 = sprite.global_transform.origin
	if not cam.is_position_behind(test_point):
		if test_point.distance_to(cam.global_transform.origin) < 10000.0:
			position_label(label, test_point)
