extends Viewport


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("display_merc",self,"_display_merc")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _display_merc(merc):
	match merc:
		"Solly":
			$"Armature/Skeleton".visible = true
			$"Armature/Skeleton2".visible = false
			$"AnimationPlayer2".play("Run")
		"Tweak":
			$"Armature/Skeleton".visible = false
			$"Armature/Skeleton2".visible = true
			$"AnimationPlayer2".play("Run2")
