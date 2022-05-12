extends Control
#
#
#onready var current = $"../../ViewportContainer/Viewport/Room"#get_tree().get_current_scene()
#func _input(event):
#	if event.is_action_pressed("ui_cancel"):
#		match Globals.Paused:
#			true:
#				visible = true
#			false:
#				visible = false
#func _ready():
#	visible = false
#
#func getallnodes(point):
#	for N in current.get_children():
#		if N.is_in_group("Player"):
#			print (N.name)
#			N.global_transform.origin = point.global_transform.origin
#
#func _on_Stage_pressed():
#	var point = current.get_node('/root/Room/First Area/Position3D')
#	getallnodes(point)
#
#func _on_Stage2_pressed():
#	var point = current.get_node('/root/Room/Second Area/Position3D')
#	getallnodes(point)
#func _on_Stage3_pressed():
#	var point = current.get_node('/root/Room/Third Area/Position3D')
#	getallnodes(point)
#
#
#
#func _on_Stage4_pressed():
#	var point = current.get_node('/root/Room/Fourth Area/Position3D')
#	getallnodes(point)
#
#func _on_Stage5_pressed():
#	var point = current.get_node('/root/Room/Fifth Area/Position3D')
#	getallnodes(point)
#
#func _on_Stage6_pressed():
#	var point = current.get_node('/root/Room/Fifth Area/Position3D2')
#	getallnodes(point)
