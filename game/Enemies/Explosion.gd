extends Sprite


func _on_AudioStreamPlayer_finished() -> void:
	queue_free()
