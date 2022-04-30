extends Control


onready var blue_number_label = $Blue/Number
onready var red_number_label = $Red/Number
# Called when the node enters the scene tree for the first time.
var red_player_no:int 
var blue_player_no:int 
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Change_Team"):
		if self.visible == true:
			self.visible = false
		else:
			self.visible = true
	if self.visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	red_number_label.text = str(red_player_no)
	blue_number_label.text = str(blue_player_no)

func set_player_no():
	red_player_no = 0
	blue_player_no = 0
	for p in Players.player_list:
		if Players.player_list[p]["team"] == 1:
			red_player_no += 1
		elif Players.player_list[p]["team"] == 2:
			blue_player_no += 1

func _on_Change_Team_visibility_changed():
	set_player_no()