extends Spatial


export (String) var label_text
onready var label = $Viewport/Label

func _ready():
	label.set_text(label_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
