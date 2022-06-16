extends Area2D

export var _speed := 50.0
export (PackedScene) var explosion_particle

var _velocity: Vector2

func shoot(dir, pos) -> void:
	position = pos
	_velocity = Vector2(_speed, 0).rotated(dir)
	rotation = dir


func _process(delta: float) -> void:
	position += _velocity * delta


func _on_Enemybullet_body_entered(body: Node) -> void:
	var explosion = explosion_particle.instance()
	explosion.rotation = rotation
	Projectiles.add_child(explosion)
	explosion.global_position = global_position
	queue_free()
	queue_free()
