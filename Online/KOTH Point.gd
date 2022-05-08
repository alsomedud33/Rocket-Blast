extends Area


var cap_rate:int

var cap_amount = 0
var max_cap = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#onready var progress = $Sprite3D/Viewport/ProgressBar
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
##	progress.value = cap_amount


func _on_Area_body_entered(body):
	if body.is_in_group("Player") and body.is_network_master():
		Network.emit_signal("koth_point_entered",body.name,Network.cap_amount,Network.cap_rate,Network.max_cap)
#		if body.team == 1:
#			cap_rate += 1
#		elif body.team == 2:
#			cap_rate -= 1

func _on_Area_body_exited(body):
	if body.is_in_group("Player") and body.is_network_master():
		Network.emit_signal("koth_point_exited",body.name,Network.cap_amount,Network.cap_rate,Network.max_cap)
#		if body.team == 1:
#			cap_rate -= 1
#		elif body.team == 2:
#			cap_rate += 1


func _on_Timer_timeout():
	Network.emit_signal("koth_points_change",Network.cap_rate)
	#cap_amount += cap_rate
	
