#tool
extends Viewport

onready var label = $RichLabel


# Called when the node enters the scene tree for the first time.
#func _ready():
#	size = $Label.rect_size *1.1


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if label.rect_size.y > 240:
		size.y = label.rect_size.y*1.2# *2
##	pass
