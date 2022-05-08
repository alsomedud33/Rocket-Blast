extends Control


onready var progress = $ProgressBar
onready var red_text = $Red/Red_Timer
onready var blue_text = $Blue/Blue_Timer

func _ready():
	#Network.connect("koth_points_change",self,"Progress_Amount")
	progress.max_value = Network.max_cap
	progress.min_value = -Network.max_cap

#func Progress_Amount(cap_rate):
#	progress.value = Network.cap_amount
#	red_text.text = "%02d : %02d" % [Network.red_time_limit_mins,Network.red_time_limit_sec]
#	blue_text.text = "%02d : %02d" % [Network.blue_time_limit_mins,Network.blue_time_limit_sec]

func _process(delta):
	progress.value = Network.cap_amount
	red_text.text = "%02d : %02d" % [Network.red_time_limit_mins,Network.red_time_limit_sec]
	blue_text.text = "%02d : %02d" % [Network.blue_time_limit_mins,Network.blue_time_limit_sec]
func _input(event: InputEvent) -> void:
	if get_parent().is_network_master():
		if event.is_action_pressed("scoreboard"):
			pass

