extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.anim.play("Idle")
	if "soft_landing" in _msg:
		player.anim_fx.play("Land_side")
	elif "landing" in _msg:
		player.anim_fx.play("Land")


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall", {"coyote": true})
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {"launch": true})
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
