extends Area2D

export var cooldown_time := 0.5
export (PackedScene) var explosion
export (PackedScene) var bullet

var target = null # will be seted as player in the level script

onready var cooldown_timer: Timer = $Cooldown
onready var init: Timer = $Init
onready var needle: Sprite = $NedleeSprite
onready var shoot_position: Position2D = $NedleeSprite/BulletPosition
onready var charging_particles: Particles2D = $ChargingParticle


func _process(delta: float) -> void:
	var aim = global_position.direction_to(target.global_position)
	needle.global_rotation = aim.angle() + PI/2
	if not cooldown_timer.is_stopped():
		charging_particles.emitting = true


func _on_Shooter_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		Events.emit_signal("enemy_died")
		var e = explosion.instance()
		Projectiles.add_child(e)
		e.global_position = global_position
		queue_free()


func _on_Cooldown_timeout() -> void:
	charging_particles.emitting = false
	var dir = target.global_position - global_position
	dir = dir.rotated(rand_range(-0.1, 0.1)).angle()
	var b = bullet.instance()
	Projectiles.add_child(b)
	b.shoot(dir, shoot_position.global_position)
	init.start()


func _on_Init_timeout() -> void:
	charging_particles.emitting = true
	cooldown_timer.start(cooldown_time)
