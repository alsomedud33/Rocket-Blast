extends Panel


onready var proj_number = $No

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	proj_number.set_text(str(Globals.proj_counter))

