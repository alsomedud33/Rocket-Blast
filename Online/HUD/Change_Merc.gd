extends Control


signal display_merc(merc)
# Called when the node enters the scene tree for the first time.

func _ready():
	self.visible = false

func _input(event):
	if Input.is_action_just_pressed("Change_Merc"):
		if self.visible == true:
			self.visible = false
		else:
			self.visible = true
	if Input.is_action_just_pressed("Change_Team"):
		self.visible = false
	if event.is_action_pressed("ui_cancel"):
		if self.visible == true:
			self.visible = false
func _on_Solly_Button_mouse_entered():
	print("Solly")
	emit_signal("display_merc","Solly")
	$"Description".text = $"Solly/Description".text
	$"Description2".text = $"Solly/Description2".text
#	$"Solly/Description".visible = true
#	$"Solly/Description2".visible = true

#func _on_Solly_mouse_exited():
#	$"Solly/Description".visible = false
#	$"Solly/Description2".visible = false

func _on_Tweak_Button_mouse_entered():
	print("Tweak")
	emit_signal("display_merc","Tweak")
	$"Description".text = $"Tweak/Description".text
	$"Description2".text = $"Tweak/Description2".text
#	$"Tweak/Description".visible = true
#	$"Tweak/Description2".visible = true

#func _on_Tweak_mouse_exited():
#	$"Tweak/Description".visible = false
#	$"Tweak/Description2".visible = false

func _on_Change_Merc_visibility_changed():
	if self.visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if self.visible == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_Solly_Button_pressed():
	Players.player_info["merc"] = "Solly"
	print("Solly")
	NetNodes.players.get_node(str(get_tree().get_network_unique_id())).health = -10000
	self.visible = false

func _on_Tweak_Button_pressed():
	Players.player_info["merc"] = "Tweak"
	print("Tweak")
	NetNodes.players.get_node(str(get_tree().get_network_unique_id())).health = -10000
	self.visible = false




