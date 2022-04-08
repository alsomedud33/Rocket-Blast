extends Spatial


var players
var rockets
var hitboxes

# Called when the node enters the scene tree for the first time.
func _ready():
	players = Spatial.new()
	rockets = Spatial.new()
	hitboxes = Spatial.new()
	players.name = "Players"
	rockets.name = "Rockets"
	hitboxes.name = "Hitboxes"
	add_child(players)
	add_child(rockets)
	add_child(hitboxes)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
