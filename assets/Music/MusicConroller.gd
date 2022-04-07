extends Node


var military_track = preload("res://assets/Music/military dnb.mp3")
var jungle_track = preload ("res://assets/Music/jungle track 1.wav")
var airport_track = preload("res://assets/Music/airportbeat.mp3")
var menu_music = preload("res://assets/Music/Menu Music.mp3")
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

func random_song():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(1,3)
	fade_out()
	yield(MusicController.tween,"tween_completed")
	print ("song: " + str(my_random_number))
	match my_random_number:
		1:
			play_music(MusicController.military_track)
		2:
			play_music(MusicController.jungle_track)
		3:
			play_music(MusicController.menu_music)
	fade_in()
