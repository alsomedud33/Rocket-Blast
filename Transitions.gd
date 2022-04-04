extends CanvasLayer


onready var anim = $AnimationPlayer

func fade_out():
	anim.play("Fade out")

func fade_in():
	anim.play("Fade In")

func _ready():
	fade_out()
