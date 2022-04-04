extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func goto_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	var loading_bar = load("res://LoadingBar.tscn").instance()
	get_tree().get_root().call_deferred('add_child',loading_bar)
	current_scene.queue_free()
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			#loading complete
			var resource = loader.get_resource()
			_deferred_goto_scene(resource, current_scene)
			#call_deferred("_deferred_goto_scene", resource, current_scene)
			loading_bar.queue_free()
			break
		if err == OK:
			#stil loading
			var progress = float(loader.get_stage())/loader.get_stage_count()
			loading_bar.get_node('AnimationPlayer').get_node("CanvasLayer").value = progress * 100
			print (progress)
		yield(get_tree(),"idle_frame")

func _deferred_goto_scene(loader, current_scene):
	# It is now safe to remove the current scene
	#current_scene.queue_free()

	# Instance the new scene.
	current_scene = loader.instance()

	# Add it to the active scene, as child of root.
	
	get_tree().get_root().add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	print(get_tree().get_current_scene().name)
