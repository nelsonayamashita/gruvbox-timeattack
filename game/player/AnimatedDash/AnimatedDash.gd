extends Sprite

export var life_time := 0.5

onready var _tween: Tween = $Tween

func _ready() -> void:
	fade()

func fade(duration := life_time) -> void:
	var transparent := modulate
	transparent.a = 0.0
	
	_tween.interpolate_property(self, "modulate", modulate, transparent, duration)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	queue_free()
