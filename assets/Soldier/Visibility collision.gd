extends Area


var items = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Visibility_collision_area_entered(area):
	items += 1
	area.get_parent().visible = true


func _on_Visibility_collision_area_exited(area):
	items -= 1
	if items <= 0:
		area.get_parent().visible = false
