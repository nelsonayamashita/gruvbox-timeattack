extends Area2D

export var speed := 50.0
export (PackedScene) var explosion

onready var _path_follow: PathFollow2D = get_parent()

func _physics_process(delta: float) -> void:
	if _path_follow.offset:
		_path_follow.offset = _path_follow.offset + speed * delta


func _on_Flyer_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		Events.emit_signal("enemy_died")
		var e = explosion.instance()
		Projectiles.add_child(e)
		e.global_position = global_position
		owner.queue_free()
