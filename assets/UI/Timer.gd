extends Label


var ms = 0
var sec = 0
var minutes = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		ms = 0
		sec = 0
		minutes = 0
	if Globals.complete == true:
		$No.text  = self.get_text()
		ms = 0
		sec = 0
		minutes = 0
		Globals.complete = false
	else:
		if ms > 9:
			sec += 1
			ms = 0
		
		if sec > 59:
			minutes += 1
			sec = 0
		
		set_text(("%02d:%02d:%02d ") % [minutes,sec,ms])
	
	

func _on_Timer2_timeout():
	ms += 1
	pass # Replace with function body.
