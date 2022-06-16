extends Node2D

enum {RUNNING, PAUSED, WON, LOST}

var Spike := preload("res://Enemies/Spike.tscn")
var _initialized := false
var state := RUNNING

onready var enemies: Node = $Enemies
onready var spikes: TileMap = $Spikes
onready var hud: CanvasLayer = $HUD
onready var shader: ColorRect = $Shader/CRT
onready var player: Player = $Player
onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("transition")
	GlobalInfo.clear_bullets()
	GlobalAudio.change_music("stop")
	_spawn_spikes()
	shader.visible = GlobalInfo.using_shaddes
	OS.window_fullscreen = GlobalInfo.full_screen
	Events.connect("shader_changed_visibility", self, "_on_shadder_changed_visibility")
	Events.connect("pause_event_pressed", self, "handle_pause")
	
	for enemy in $Enemies.get_children():
		if enemy.is_in_group("chaser"):
			enemy.target = player


func handle_pause() -> void:
	if state == RUNNING:
		_change_state(PAUSED)
	elif state == PAUSED:
		_change_state(RUNNING)


func _process(_delta: float) -> void:
	if enemies.get_child_count() == 0 and state == RUNNING:
		_change_state(WON)


func _change_state(new_state) -> void:
	state = new_state
	match state:
		RUNNING:
			hud.unpause()
		PAUSED:
			hud.pause()
		WON:
			GlobalInfo.unlocked_levels = max(
				GlobalInfo.unlocked_levels,
				GlobalInfo.current_level + 1
			)
			hud.timer.paused = true
			player.state_machine.transition_to("NoControl", {"win" : true})
		LOST:
			hud.timer.paused = true
			player.state_machine.transition_to("NoControl", {"die" : true})

func _spawn_spikes() -> void:
	for cell in spikes.get_used_cells():
		var id = spikes.get_cellv(cell)
		var type = spikes.tile_set.tile_get_name(id)
		
		var spike = Spike.instance()
		var pos = spikes.map_to_world(cell) 
		spike.position = pos + spikes.cell_size / 2
		spike.position *= spikes.scale.x
		
		match type:
			"right":
				spike.rotate(PI/2)
			"down":
				spike.rotate(PI)
			"left":
				spike.rotate(3*PI/2)
		
		spikes.set_cellv(cell, -1)
		add_child(spike)


func _on_shadder_changed_visibility(value: bool) -> void:
	shader.visible = value
	GlobalInfo.using_shaddes = value


func _on_Player_died() -> void:
	if state == RUNNING:
		_change_state(LOST)
