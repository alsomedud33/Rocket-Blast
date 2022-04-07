extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LineEdit.text = "127.0.0.1"
	Transitions.fade_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Create_button_pressed():
	Network.create_server()
	hide()
	print(str(get_tree().get_network_unique_id()) + " started server")

func _on_Join_button_pressed():
	Network.join_server()
	hide()
	print(str(get_tree().get_network_unique_id()) + " jointed server")

func _on_Exit_button_pressed():
	get_tree().quit()


func _on_LineEdit_text_changed(new_text):
	Network.ip_address = new_text
