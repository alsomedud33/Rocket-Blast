extends Spatial


export (String) var label_text
onready var label = $Viewport/RichLabel

func _ready():
	label.set_text(label_text)
#	label.scroll_to_line(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	pass
#	label.remove_line(1)
	#label.add_text("hello")
	#label.scroll_to_line(label.get_line_count()-1)
	#print (label.get_line_count())
	
