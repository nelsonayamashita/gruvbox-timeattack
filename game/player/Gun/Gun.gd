class_name Gun
extends Node2D

export (PackedScene) var bullet_scene
export var max_charge_time := 2.0

var direction := Vector2.ZERO
var charge_time := 0.0
var is_charging := false
var max_charge := false
var max_charge_audio_done := true
var line_length := 64
var player: Player

onready var _charge_sfx: AudioStreamPlayer = $GunCharge
onready var _max_charge_sfx: AudioStreamPlayer = $GunMaxCharge
onready var _shoot_sfx: AudioStreamPlayer = $GunShoot
onready var _shoot_position := $ShootPosition
onready var _line := $ShotArc

func _ready() -> void:
	yield(owner, "ready")
	player = owner as Player
	assert(player != null, "Owner of Gun is not a Player")


func _physics_process(delta: float) -> void:
	var angle = Vector2(abs(direction.x), direction.y).angle()
	rotation = angle
	
	if Input.is_action_just_pressed("shoot") and player.can_shoot:
		is_charging = true
		player.charging_particle.emitting = true
		_charge_sfx.play()
	elif Input.is_action_just_pressed("shoot") and not player.can_shoot:
		player.cantdo_sfx.play()
	
	if Input.is_action_just_released("shoot") and is_charging:
		is_charging = false
		player.charging_particle.emitting = false
		_shoot()
	if is_charging:
		if max_charge and max_charge_audio_done:
			max_charge_audio_done = false
			_max_charge_sfx.play()
		if charge_time + delta > max_charge_time:
			max_charge = true
		charge_time = min(charge_time + delta, max_charge_time)
		_line.show()
		_update_trajectory(delta)

func _update_trajectory(delta):
	var pos: Vector2 = _shoot_position.position
	_line.add_point(pos + Vector2(
		line_length * log_scale(charge_time / max_charge_time, 10) + 8, 
		0)
	)

# Make the size scale logarithimc
func log_scale(x:float , base: float) -> float:
	return (log(x + 0.1) / log(base)) + 1


func _shoot() -> void:
	_shoot_sfx.play()
	_charge_sfx.stop()
	_max_charge_sfx.stop()
	_line.clear_points()
	_line.hide()
	max_charge = false
	player.can_shoot = false
	var bullet = bullet_scene.instance()
	bullet.direction = direction.rotated(0)
	Projectiles.add_child(bullet)
	bullet.global_position = _shoot_position.global_position
	
	bullet.charge =  charge_time / max_charge_time
	
	Events.emit_signal("shake_event_occured", 0.3)
	
	charge_time = 0


func _on_GunCharge_finished() -> void:
	max_charge = true


func _on_GunMaxCharge_finished() -> void:
	max_charge_audio_done = true
