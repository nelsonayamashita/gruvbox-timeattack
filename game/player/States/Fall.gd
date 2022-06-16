extends PlayerState

onready var _input_buffer := $InputBufferTimer
onready var _coyote_timer := $CoyoteTimer

func enter(_msg := {}) -> void:
	player.anim.play("Fall")
	if "coyote" in _msg:
		_coyote_timer.start()


func physics_update(_delta: float) -> void:
	var target_speed: float = player.speed * player.movement_direction
	
	player.velocity.x = target_speed
	
	if player.is_on_floor():
		if not _input_buffer.is_stopped():
			state_machine.transition_to("Jump", {"launch": true})
		elif is_equal_approx(player.movement_direction, 0.0):
			player.land_sfx.play()
			state_machine.transition_to("Idle", {"landing" : true})
		else:
			state_machine.transition_to("Run", {"landing" : true})
	
	if Input.is_action_just_pressed("jump"):
		if player.can_air_jump:
			player.can_air_jump = false
			state_machine.transition_to("Jump", {"launch": true})
		elif not _coyote_timer.is_stopped():
			state_machine.transition_to("Jump", {"launch": true})
		else:
			_input_buffer.start()
	
	if player.can_air_jump and not _input_buffer.is_stopped():
		player.can_air_jump = false
		_input_buffer.stop()
		state_machine.transition_to("Jump", {"launch": true})
		
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_pressed("shoot"):
		state_machine.transition_to("Float")
	
	if player.is_on_wall():
		if not _input_buffer.is_stopped():
			var wall_normal = player.get_slide_collision(0).normal
			player.velocity = player.jump_speed / 2 * wall_normal.rotated(PI/4)
			state_machine.transition_to("WallJump", {"soft_launch" : true})
		else:
			state_machine.transition_to("OnWall", {"soft_landing": true})


func exit() -> void:
	_coyote_timer.stop()
