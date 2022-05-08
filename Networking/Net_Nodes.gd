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

func clear_nodes():
	for p in players.get_children():
		players.remove_child(p)
		p.queue_free()
		
	for r in rockets.get_children():
		rockets.remove_child(r)
		r.queue_free()
		
	for h in hitboxes.get_children():
		hitboxes.remove_child(h)
		h.queue_free()
