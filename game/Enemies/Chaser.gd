extends Area2D

export var _speed := 75.0
export var wait_time: float = 1.0
export var init_time: float = 2.0
export (PackedScene) var explosion

var _velocity := Vector2.ZERO
var _is_waiting: bool = false
var target = null # will be seted as player by level script

onready var wait_timer: Timer = $WaitTimer

func _ready() -> void:
	wait_timer.start(init_time)


func _physics_process(delta: float) -> void:
	position += _velocity * delta


func _on_WaitTimer_timeout() -> void:
	wait_timer.start(wait_time)
	if _is_waiting:
		_is_waiting = false
		_velocity = Vector2.ZERO
	else:
		_is_waiting = true
		var direction = (target.global_position - global_position).normalized()
		_velocity = direction * _speed


func _on_Chaser_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		Events.emit_signal("enemy_died")
		var e = explosion.instance()
		Projectiles.add_child(e)
		e.global_position = global_position
		queue_free()
