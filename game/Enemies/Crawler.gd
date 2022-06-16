extends KinematicBody2D

export var speed := 50.0
export var gravity := 900.0

var velocity := Vector2()
var direction := 1

onready var right_ray: RayCast2D = $FloorCheckRight
onready var left_ray: RayCast2D = $FloorCheckLeft

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.normal.x != 0:
			direction = sign(collision.normal.x)
	
	if not right_ray.is_colliding():
		direction = -1
	elif not left_ray.is_colliding():
		direction = 1


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		Events.emit_signal("enemy_died")
		queue_free()
