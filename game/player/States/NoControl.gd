extends PlayerState

func enter(msg := {}) -> void:
	if "win" in msg:
		player.anim.play("Win")
	elif "die" in msg:
		player.anim.play("Die")
	else:
		player.anim.play("Idle")
		player.anim_fx.play("Blink")
	
	player.velocity = Vector2.ZERO
	player.gravity_multipler = 0
	player.hitbox.set_deferred("monitoring", false)


func exit() -> void:
	player.hitbox.monitoring = true
	player.gravity_multipler = 1


func _on_Anim_animation_finished(anim_name: String) -> void:
	match anim_name:
		"Win":
			Events.emit_signal("no_control_animation_ended", anim_name)
		"Die":
			Events.emit_signal("no_control_animation_ended", anim_name)


func _on_Anim_FX_animation_finished(anim_name: String) -> void:
	if anim_name == "Blink":
		Events.emit_signal("player_ready")
		state_machine.transition_to("Idle")
