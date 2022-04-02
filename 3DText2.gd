extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var text = "Waypoint" setget set_text
onready var label = $Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_text(p_text):
	text = p_text

	# The label's text can only be set once the node is ready.
	if is_inside_tree():
		label.text = p_text
