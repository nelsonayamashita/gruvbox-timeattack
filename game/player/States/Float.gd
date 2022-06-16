extends PlayerState

onready var _hold_timer := $HoldTimer

func enter(_msg := {}) -> void:
	if not player.can_shoot:
		_go_to_next_state()
		return
	
	player.gravity_multipler = 0.0
	player.velocity /= 10
	_hold_timer.start()


func update(_delta: float) -> void:
	if not Input.is_action_pressed("shoot"):
		_hold_timer.stop()
		_go_to_next_state()
	if Input.is_action_just_pressed("jump") and player.can_air_jump:
		player.can_air_jump = false
		state_machine.transition_to("Jump", {"launch": true})


func exit() -> void:
	_hold_timer.stop()
	player.gravity_multipler = 1.0


func _go_to_next_state():
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	elif player.is_on_wall():
		state_machine.transition_to("OnWall")
	else:
		state_machine.transition_to("Fall")
