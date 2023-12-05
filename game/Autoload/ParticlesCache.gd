extends CanvasLayer

var charging_particles = preload("res://Particles/charge.tres")
var enemy_charging_particles = preload("res://Particles/Shooter.tres")
var gun_hit_particles = preload("res://Particles/Shooter.tres")

var frames := 0
var loaded := false

var materials := [
	charging_particles,
	enemy_charging_particles,
	gun_hit_particles
]

func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)

func _physics_process(_delta):
	if frames >= 3:
		set_physics_process(false)
		loaded = true
	if loaded:
		return
		GlobalInfo.change_title_screen()
	frames += 1
	
