extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity.y = -player.jump_speed
	player.anim.play("Jump")
	player.set_jump_random_pitch()
	if "soft_launch" in _msg:
		player.anim_fx.play("Launch_side")
	elif "launch" in _msg:
		player.anim_fx.play("Launch")

func physics_update(delta: float) -> void:
	if player.velocity.y >= 0:
		state_machine.transition_to("Fall")
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_pressed("shoot"):
		state_machine.transition_to("Float")
	
	if Input.is_action_just_pressed("jump"):
		if player.can_air_jump:
			player.can_air_jump = false
			state_machine.transition_to("Jump", {"launch": true})
	
	var target_speed = player.speed * player.movement_direction
	
	player.velocity.x = lerp(player.velocity.x, target_speed, delta * 6)
