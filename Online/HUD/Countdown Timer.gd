extends AnimationPlayer


func _process(delta):
#	print (floor(Globals.round_time_s))
#	if Globals.player_1["stocks"] == 0 or Globals.player_2["stocks"] == 0:
#		play ("Game")
	if (round(Network.red_time_limit_mins) == 0 and floor(Network.red_time_limit_sec) == 5) or (round(Network.blue_time_limit_mins) == 0 and floor(Network.blue_time_limit_sec) == 5):
		play ("5")
	if (round(Network.red_time_limit_mins) == 0 and floor(Network.red_time_limit_sec) == 4) or (round(Network.blue_time_limit_mins) == 0 and floor(Network.blue_time_limit_sec) == 4):
		play ("4")
	if (round(Network.red_time_limit_mins) == 0 and floor(Network.red_time_limit_sec) == 3) or (round(Network.blue_time_limit_mins) == 0 and floor(Network.blue_time_limit_sec) == 3):
		play ("3")
	if (round(Network.red_time_limit_mins) == 0 and floor(Network.red_time_limit_sec) == 2) or (round(Network.blue_time_limit_mins) == 0 and floor(Network.blue_time_limit_sec) == 2):
		play ("2")
	if (round(Network.red_time_limit_mins) == 0 and floor(Network.red_time_limit_sec) == 1) or (round(Network.blue_time_limit_mins) == 0 and floor(Network.blue_time_limit_sec) == 1):
		play ("1")
	if (round(Network.red_time_limit_mins) == 0 and floor(Network.red_time_limit_sec) == 0) or (round(Network.blue_time_limit_mins) == 0 and floor(Network.blue_time_limit_sec) == 0):
		play ("Time")

func game_end():
	Network.emit_signal("winner",1)
