extends Button

export(String) var action_name = ""

var do_set = false

func _pressed():
	text = ""
	do_set = true
	
func _input(event):
	if(do_set):
		if(event is InputEventKey):
			#Remove the old keys
			var newkey = InputEventKey.new()
			newkey.scancode = int(Globals.key_dict[action_name])
			InputMap.action_erase_event(action_name,newkey)
			#Add the new key for this action
			InputMap.action_add_event(action_name,event)
			#Show it as readable to the user
			text = OS.get_scancode_string(event.scancode)
			#Update the keydictionary with the scanscode to save
			Globals.key_dict[action_name] = event.scancode
			#Save the dictionary to json
			Globals.save_keys()
			#stop setting the key
			do_set = false
		elif event is InputEventMouseButton:
			#Remove the old keys
			var newkey = InputEventKey.new()
			newkey.scancode = int(Globals.key_dict[action_name])
			InputMap.action_erase_event(action_name,newkey)
			#Add the new key for this action
			InputMap.action_add_event(action_name,event)
			#Show it as readable to the user
			text = index_to_text(event.button_index)#event.as_text()#str(event.button_index)#event.as_text()
			#Update the keydictionary with the scanscode to save
			Globals.key_dict[action_name] = event.button_index
			#Save the dictionary to json
			Globals.save_keys()
			#stop setting the key
			do_set = false

func index_to_text(index):
	var text:String
	match index:
			1:
				text = "Mouse 1"
			2:
				text = "Mouse 2"
			3:
				text = "BUTTON_MIDDLE"
			4:
				text = "MWHEELUP"
			5:
				text = "MWHEELDOWN"
			8:
				text = "SIDE_BTN_1"
			9:
				text = "SIDE_BTN_2"
	return text
