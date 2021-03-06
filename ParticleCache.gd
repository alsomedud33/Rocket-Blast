extends CanvasLayer



var explosion = preload("res://assets/Materials/Explosion.tres")
var explosion2 = preload("res://assets/Materials/Explosion2.tres")
var explosion3 = preload("res://assets/Materials/Explosion3.tres")
var explosion4 = preload("res://assets/Materials/Explosion4.tres")
var explosion5 = preload("res://assets/Materials/Explosion5.tres")
var fire = preload("res://assets/Materials/Fire.tres")
var smoke = preload("res://assets/Materials/Smoke3.tres")
var second_pass = preload("res://assets/Materials/Second Pass.tres")
var third_pass = preload("res://assets/Materials/Third Pass.tres")
var materials = [
	explosion,
	explosion2,
	explosion3,
	explosion4,
	explosion5,
	fire,smoke,
	second_pass,
	third_pass
	]

var frames = 0
var loaded = false

func _ready():
	for material in materials:
		var particles_instance = Particles.new()
		particles_instance.set_process_material(material)
		#particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		particles_instance.set_one_shot(true)
		self.add_child(particles_instance)#call_deferred("add_child",particles_instance)
		#self.add_child(particles_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if frames >=3:
		set_physics_process(false)
		loaded = true
	frames =+1
