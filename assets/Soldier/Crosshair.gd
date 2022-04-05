extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_position.x = ProjectSettings.get_setting('display/window/size/width')/2
	self.rect_position.y = ProjectSettings.get_setting('display/window/size/height')/2

