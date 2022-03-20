extends Panel


onready var proj_number = $No
onready var proj_name = $Proj_name

func _ready():
	match Globals.player:
		1:
			proj_name.set_text("Rockets:")
		2:
			proj_name.set_text("Stickies:")
	Globals.proj_counter = 0
	self.visible = false

func _process(delta):
	if Globals.complete == true:
		proj_number.set_text(str(Globals.proj_counter))
		self.visible = true

