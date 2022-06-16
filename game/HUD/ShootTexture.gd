extends TextureRect

func _on_can_shoot_changed(can_shoot: bool) -> void:
	if can_shoot:
		modulate = Color(1, 1 , 1, 1)
	else:
		modulate = Color(0.5, 0.5, 0.5, 0.5)
