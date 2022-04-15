extends Spatial

export var amount:float = 0.5
export var overheal:bool = false
export var is_multiplier:bool = true

var has_pack = false

func _ready():
	$MeshInstance.visible = false
	if !has_pack:
		var medium_pack = Network.health_pack.instance()
		medium_pack.amount = amount
		medium_pack.overheal = overheal
		medium_pack.is_multiplier = is_multiplier
		$Pivot.add_child(medium_pack)
		medium_pack.connect("picked_up",self,"pack_picked")
		print ("I exist")

func pack_picked():
	print("Pack picked up")
	$Cooldown.start()
	has_pack = false


func _on_Cooldown_timeout():
	var medium_pack = Network.health_pack.instance()
	medium_pack.amount = amount
	medium_pack.overheal = overheal
	medium_pack.is_multiplier = is_multiplier
	$Pivot.add_child(medium_pack)
	medium_pack.connect("picked_up",self,"pack_picked")
	has_pack = true
