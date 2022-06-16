class_name Player
extends KinematicBody2D

signal died()

export var jump_height := 80
export var jump_duration := 0.3
export var speed := 224
export var dash_distance := 96
export var dash_duration := 0.1

# This variables will be calculated bellow
var gravity := -1.0
var jump_speed := -1.0
var movement_direction := -1.0
var facing_direction := -1.0
var dash_speed := -1.0
var aim_direction := Vector2.RIGHT

var velocity := Vector2.ZERO
var gravity_multipler := 1.0

var can_dash := true 
var can_shoot := true setget set_can_shoot
var can_air_jump := false setget set_can_air_jump

onready var _body := $Body
onready var _gun := $Body/Gun
onready var sprite: Sprite = $Sprite 
onready var charging_particle: Particles2D = $ChargingParticle
onready var anim: AnimationPlayer = $Anim
onready var anim_fx: AnimationPlayer = $Anim_FX

onready var step_sfx: AudioStreamPlayer = $StepSFX
onready var jump_sfx: AudioStreamPlayer = $JumpSFX
onready var land_sfx: AudioStreamPlayer = $LandSFX
onready var dash_sfx: AudioStreamPlayer = $DashSFX
onready var cantdo_sfx: AudioStreamPlayer = $CantdoSFX

onready var dash_cooldown: Timer = $DashCooldown
onready var dash_hitbox: Area2D = $DashArea
onready var hitbox: Area2D = $Hitbox
onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	gravity = 2 * jump_height / pow(jump_duration, 2)
	jump_speed = sqrt(2 * gravity * jump_height) # Torricelli
	dash_speed = dash_distance / dash_duration
	Events.connect("enemy_died", self, "_on_enemy_died")


func _process(_delta: float) -> void:
	Events.emit_signal(
		"dash_cooldown_changed", 
		dash_cooldown.wait_time - dash_cooldown.time_left
	)
	
	if self.is_on_floor():
		set_can_air_jump(false)


func _physics_process(delta: float) -> void:
	movement_direction = Input.get_axis("left", "right")
	aim_direction = _gun.global_position.direction_to(get_global_mouse_position())
	
	var new_facing_direction: float
	new_facing_direction = global_position.direction_to(get_global_mouse_position()).x
	
	if not is_equal_approx(new_facing_direction, 0.0):
		facing_direction = int(sign(new_facing_direction))
	
	_body.scale.x = facing_direction
	_gun.direction = aim_direction
	if aim_direction == Vector2.ZERO:
		_gun.direction.x = facing_direction
	
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	velocity.y += gravity * gravity_multipler * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func set_step_random_pitch() -> void:
	step_sfx.pitch_scale = 1.0 + 0.2 * rand_range(-1, 1)
	step_sfx.play()

func set_jump_random_pitch() -> void:
	jump_sfx.pitch_scale = 1.0 + 0.2 * rand_range(-1, 1)
	jump_sfx.play()


func set_can_shoot(value: bool) -> void:
	can_shoot = value
	Events.emit_signal("can_shoot_changed", value)


func set_can_air_jump(value: bool) -> void:
	can_air_jump = value
	if can_air_jump:
		sprite.modulate = Color(1.274, 1.924, 2.34, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 1)
	

func _on_enemy_died() -> void:
	set_can_shoot(true)
	set_can_air_jump(true)


func _on_DashCooldown_timeout() -> void:
	can_dash = true


func _on_Hitbox_area_entered(_area: Area2D) -> void:
	Events.emit_signal("shake_event_occured", 0.3)
	emit_signal("died")
