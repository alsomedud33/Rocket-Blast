extends Control


onready var current = get_tree().get_current_scene()
func _input(event):
	if event.is_action_pressed("ui_cancel"):
			if get_tree().is_paused():
				visible = false
			else:
				visible = true

func getallnodes(point):
	for N in current.get_children():
		if N.is_in_group("Player"):
			print (N.name)
			N.global_transform.origin = point.global_transform.origin

func _on_Stage_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('First Area/Position3D')
	getallnodes(point)

func _on_Stage2_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('First Area B/Position3D')
	getallnodes(point)
func _on_Stage3_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('Second Area/Position3D')
	getallnodes(point)



func _on_Stage4_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('/root/Room/Third Area/Position3D')
	getallnodes(point)

func _on_Stage5_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('/root/Room/Fourth Area/Position3D')
	getallnodes(point)

func _on_Stage6_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('/root/Room/First_Ground_Skip/Position3D')
	getallnodes(point)


func _on_Stage7_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('/root/Room/Wall Shots/Position3D')
	getallnodes(point)

func _on_Stage8_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('/root/Room/Ground Skip/Position3D')
	getallnodes(point)

func _on_Stage9_pressed():
	current = get_tree().get_current_scene()
	var point = current.get_node('/root/Room/Jurf Walls/Position3D')
	getallnodes(point)
	
func contact_1(body):
	$'Panel/VBoxContainer/HBoxContainer/Stage'.disabled = false

func contact_2(body):
	$'Panel/VBoxContainer/HBoxContainer/Stage2'.disabled = false

func contact_3(body):
	$'Panel/VBoxContainer/HBoxContainer/Stage3'.disabled = false


func contact_4(body):
	$'Panel/VBoxContainer/HBoxContainer2/Stage4'.disabled = false


func contact_5(body):
	$'Panel/VBoxContainer/HBoxContainer2/Stage5'.disabled = false


func contact_6(body):
	$'Panel/VBoxContainer/HBoxContainer3/Stage8'.disabled = false


func contact_7(body):
	$'Panel/VBoxContainer/HBoxContainer2/Stage6'.disabled = false


func contact_8(body):
	$'Panel/VBoxContainer/HBoxContainer3/Stage7'.disabled = false


func contact_9(body):
	$'Panel/VBoxContainer/HBoxContainer3/Stage9'.disabled = false
