extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity.y = -player.jump_speed
	player.anim.play("Jump")
	if "soft_launch" in _msg:
		player.anim_fx.play("Launch_side")
	elif "launch" in _msg:
		player.anim_fx.play("Launch")
	player.set_jump_random_pitch()
	
func physics_update(_delta: float) -> void:
	if player.velocity.y > 0:
		state_machine.transition_to("Fall")
	
	var target_speed: float = player.speed * player.movement_direction
	
	player.velocity.x = target_speed
	
	if Input.is_action_just_pressed("jump"):
		if player.can_air_jump:
			player.can_air_jump = false
			state_machine.transition_to("Jump", {"launch": true})
	
	if Input.is_action_just_released("jump"):
		player.velocity.y /= 3.0
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_pressed("shoot"):
		state_machine.transition_to("Float")
