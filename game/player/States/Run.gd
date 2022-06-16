extends PlayerState

var _sound_playing := false

func enter(_msg := {}) -> void:
	player.anim.play("Run")
	if "soft_landing" in _msg:
		player.anim_fx.play("Land_side")
	elif "landing" in _msg:
		player.anim_fx.play("Land")


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Fall", {"coyote": true})
		return
	
	player.velocity.x = player.speed * player.movement_direction
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump", {"launch" : true})
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif is_equal_approx(player.movement_direction, 0.0):
		state_machine.transition_to("Idle")
	
	if not _sound_playing:
		_sound_playing = true
		player.set_step_random_pitch()


func exit() -> void:
	#_sound_playing = false
	player.step_sfx.stop()

func _on_Step_finished() -> void:
	_sound_playing = false
