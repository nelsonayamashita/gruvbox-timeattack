extends PlayerState

const WALL_FRICTION := 0.3

var wall_normal := Vector2.ZERO
var release_wall := false
var friction_modifier := 1.0

onready var _release_timer := $ReleaseTimer

func enter(_msg := {}) -> void:
	wall_normal = player.get_slide_collision(0).normal
	player.velocity.x = -player.speed * sign(wall_normal.x)
	player.anim.play("Wall")
	player.land_sfx.play()
	if "soft_landing" in _msg:
		player.anim_fx.play("Land_side")
	elif "landing" in _msg:
		player.anim_fx.play("Land")


func physics_update(_delta: float) -> void:
	player.velocity.y -= player.velocity.y * WALL_FRICTION * friction_modifier
	
	var away_from_wall := sign(player.movement_direction * wall_normal.x) > 0
	
	if not away_from_wall:
		_release_timer.stop()
	elif _release_timer.is_stopped():
		_release_timer.start()
	
	if not release_wall:
		player.velocity.x = -player.speed * sign(wall_normal.x)
	else:
		player.velocity.x = player.movement_direction
	
	if Input.is_action_pressed("down"):
		friction_modifier = 0.5
	else:
		friction_modifier = 1.0
	
	if not player.is_on_wall():
		state_machine.transition_to("Fall", { "coyote": true })
		return
	
	if Input.is_action_just_pressed("jump"):
		player.velocity = player.jump_speed / 2 * wall_normal.rotated(PI/4)
		state_machine.transition_to("WallJump", {"soft_launch" : true})
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	if player.is_on_floor():
		state_machine.transition_to("Idle", {"soft_landing" : true})


func exit() -> void:
	release_wall = false
	_release_timer.stop()
	friction_modifier = 1.0


func _on_ReleaseTimer_timeout() -> void:
	release_wall = true
