extends Node


var military_track = preload("res://assets/Music/military dnb.mp3")
var jungle_track = preload ("res://assets/Music/jungle track 1.wav")
var airport_track = preload("res://assets/Music/airportbeat.mp3")
onready var tween = $Tween
onready var music = $Music
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_music(name):
	music.stream = name
	music.play()


func fade_out():
	tween.interpolate_property($Music,"volume_db",null,-60,1,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func fade_in():
	tween.interpolate_property($Music,"volume_db",null,0,1,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	tween.start()




func _on_Music_finished():
	music.play()
