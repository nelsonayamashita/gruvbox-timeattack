extends RigidBody2D

export var max_impulse := 500.0
export var min_impulse := 250.0
export (PackedScene) var explosion_particle

var direction := Vector2.RIGHT setget set_direction
var charge := 0.0 setget set_charge

func _physics_process(_delta: float) -> void:
	look_at(global_position + get_linear_velocity())


func set_direction(new_direction: Vector2) -> void:
	direction = new_direction


func set_charge(new_charge: float) -> void:
	charge = new_charge
	apply_central_impulse((direction * max_impulse * charge) + min_impulse * direction)


func _on_Area2D_body_entered(_body: Node) -> void:
	var explosion = explosion_particle.instance()
	explosion.rotation = rotation
	Projectiles.add_child(explosion)
	explosion.global_position = global_position
	queue_free()
