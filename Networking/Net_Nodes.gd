extends Spatial


var players
var rockets
var hitboxes
var objectives
onready var viewport = $ViewportContainer/Viewport
# Called when the node enters the scene tree for the first time.
func _ready():
	players = Spatial.new()
	rockets = Spatial.new()
	hitboxes = Spatial.new()
	objectives = Spatial.new()
	players.name = "Players"
	rockets.name = "Rockets"
	hitboxes.name = "Hitboxes"
	objectives.name = "Objectives"
	viewport.add_child(players)
	viewport.add_child(rockets)
	viewport.add_child(hitboxes)
	viewport.add_child(objectives)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
