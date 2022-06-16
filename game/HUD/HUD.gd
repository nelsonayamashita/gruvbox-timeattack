extends CanvasLayer

export var _level_time := 30.0

var _changed := false
var _timer_started := false

onready var timer: Timer = $LevelTimer
onready var time_label: Label = $InformationHUD/ElementsContainer/TimerLabel
onready var dash_circle: TextureProgress = $InformationHUD/ElementsContainer/LeftContainer/CooldownBar
onready var ammo_icon: TextureRect = $InformationHUD/ElementsContainer/LeftContainer/ShootTexture
onready var time_bar: ProgressBar = $InformationHUD/ElementsContainer/MarginContainer/ProgressBar
onready var message_label: Label = $Message
onready var pause_screen: Control = $Pause
onready var lost_screen: Control = $Lost
onready var win_screen: Control = $Win

func _ready() -> void:
	Events.connect("dash_cooldown_changed", dash_circle, "_on_cooldown_changed")
	Events.connect("can_shoot_changed", ammo_icon, "_on_can_shoot_changed")
	Events.connect("no_control_animation_ended", self, "_on_control_animation_ended")
	Events.connect("player_ready", self, "start_timer")
	
	timer.wait_time = _level_time
	time_bar.max_value = _level_time
	time_bar.get("custom_styles/fg").set_bg_color(Color("#ebdbb2"))


func _process(_delta: float) -> void:
	var time_left: float
	if not _timer_started:
		time_left = timer.wait_time
	else:
		time_left = timer.time_left
	
	var mile := fmod(time_left, 1) * 100
	var seconds := fmod(time_left, 60)
	
	var time_string := "%02d.%02d" % [seconds, mile]
	
	time_label.text = time_string
	time_bar.value = time_left
	
	if time_left < 5.0 and not _changed:
		_changed = true
		time_label.add_color_override("font_color", Color("#fb4934"))
		time_bar.get("custom_styles/fg").set_bg_color(Color("#fb4934"))


func start_timer() -> void:
	GlobalAudio.change_music("level")
	_timer_started = true
	timer.start()


func unpause() -> void:
	get_tree().paused = false
	pause_screen.disappear()


func pause() -> void:
	pause_screen.pop_up()
	get_tree().paused = true


func game_over() -> void:
	lost_screen.pop_up()
	get_tree().paused = true


func game_win() -> void:
	win_screen.pop_up(timer.wait_time - timer.time_left)
	get_tree().paused = true


func _on_control_animation_ended(state: String) -> void:
	match state:
		"Win":
			game_win()
		"Die":
			game_over()


func _on_LevelTimer_timeout() -> void:
	game_over()
