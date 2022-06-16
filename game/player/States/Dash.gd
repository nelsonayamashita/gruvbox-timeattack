extends PlayerState

onready var _dash_timer: Timer = $DashTimer
onready var _hold_timer: Timer = $HoldTimer


func enter(_msg := {}) -> void:
	if not player.can_dash:
		player.cantdo_sfx.play()
		_go_to_next_state()
		return
	
	player.gravity_multipler = 0.0
	player.velocity /= 10
	player.hitbox.monitoring = false
	_hold_timer.start()


func update(_delta: float) -> void:
	
	if Input.is_action_just_released("dash") and player.can_dash:
		_hold_timer.stop()
		_dash()
	
	if player.is_on_wall() and not _dash_timer.wait_time:
		state_machine.transition_to("OnWall")
	
	if Input.is_action_just_pressed("shoot") and not player.is_on_floor():
		state_machine.transition_to("Float")


func exit() -> void:
	_dash_timer.stop()
	_hold_timer.stop()
	player.gravity_multipler = 1.0
	player.dash_hitbox.monitorable = false
	player.hitbox.monitoring = true
	player.sprite.is_emitting = false


func _dash() -> void:
	player.can_dash = false
	player.dash_hitbox.monitorable = true
	player.anim.play("Dash")
	player.anim_fx.play("Launch")
	player.dash_sfx.play()
	player.sprite.is_emitting = true
	
	var dir = _get_discrete_direction(
		player.aim_direction.angle_to(Vector2.RIGHT)
	)
	
	player.velocity = dir * player.dash_speed 

	_dash_timer.wait_time = player.dash_duration
	_dash_timer.start()
	player.dash_cooldown.start()
	
#	player.sprite.modulate = Color(1.274, 1.924, 2.34, 1)
	
	Events.emit_signal("shake_event_occured", 0.3)



func _go_to_next_state():
	if player.is_on_floor():
		state_machine.transition_to("Idle", {"landing" : true})
	elif player.is_on_wall():
		state_machine.transition_to("OnWall", {"landing" : true})
	else:
		state_machine.transition_to("Fall")


func _get_discrete_direction(rad: float) -> Vector2:
	var dir: Vector2
	rad += PI
	if rad > 0 and rad <= PI/8:
		dir = Vector2.LEFT
	elif rad > PI/8 and rad <= 3*PI/8:
		dir = Vector2(-1,1).normalized()
	elif rad > 3*PI/8 and rad <= 5*PI/8:
		dir = Vector2.DOWN
	elif rad > 5*PI/8 and rad <= 7*PI/8:
		dir = Vector2(1,1).normalized()
	elif rad > 7*PI/8 and rad <= 9*PI/8:
		dir = Vector2.RIGHT
	elif rad > 9*PI/8 and rad <= 11*PI/8:
		dir = Vector2(1,-1).normalized()
	elif rad > 11*PI/8 and rad <= 13*PI/8:
		dir = Vector2.UP
	elif rad > 13*PI/8 and rad <= 15*PI/8:
		dir = Vector2(-1,-1).normalized()
	else:
		dir = Vector2.LEFT
	
	return dir


func _on_DashTimer_timeout() -> void:
	player.velocity /= 5.0
	_go_to_next_state()


func _on_DashCooldown_timeout() -> void:
	player.can_dash = true
