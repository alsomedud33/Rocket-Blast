extends MeshInstance

signal picked_up

var amount:float
var overheal:bool 
var is_multiplier:bool 

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_health(amount,overheal,is_multiplier)
		emit_signal("picked_up")
		queue_free()
