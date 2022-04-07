extends Spatial


var players
var rockets

# Called when the node enters the scene tree for the first time.
func _ready():
	players = Spatial.new()
	rockets = Spatial.new()
	players.name = "Players"
	rockets.name = "Rockets"
	add_child(players)
	add_child(rockets)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
