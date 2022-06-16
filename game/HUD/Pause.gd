extends Control

onready var check_button: CheckButton = $Menu/Elements/ShadderContainer/CheckButton
onready var fullscreen_button: CheckButton = $Menu/Elements/FullscreenContainer2/FullscreenButton
onready var sfx_scroll: HSlider = $Menu/Elements/SFXBoxContainer/SFXSlider
onready var music_scroll: HSlider = $Menu/Elements/MusicBoxContainer/MusicSlider
onready var anim_player: AnimationPlayer = $AnimationPlayer

onready var pause_sfx: AudioStreamPlayer = $PauseSFX
onready var options_sfx: AudioStreamPlayer = $OptionSFX

func _ready() -> void:
	check_button.pressed = GlobalInfo.using_shaddes
	fullscreen_button.pressed = OS.window_fullscreen
	sfx_scroll.value = GlobalInfo.sfx_volume
	music_scroll.value = GlobalInfo.music_volume


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		Events.emit_signal("pause_event_pressed")


func pop_up() -> void:
	pause_sfx.play()
	anim_player.play("Pop")


func disappear() -> void:
	pause_sfx.play()
	anim_player.play("Disappear")


func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	GlobalAudio.play_change_scene_sfx()
	GlobalInfo.restart()


func _on_LevelsButton_pressed() -> void:
	get_tree().paused = false
	GlobalAudio.play_change_scene_sfx()
	GlobalInfo.change_level_menu()


func _on_HomeButton_pressed() -> void:
	GlobalAudio.play_change_scene_sfx()
	get_tree().paused = false
	GlobalInfo.change_title_screen()


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	if is_visible_in_tree():
		options_sfx.play()
	Events.emit_signal("shader_changed_visibility", button_pressed)


func _on_FullscreenButton_toggled(button_pressed: bool) -> void:
	if is_visible_in_tree():
		options_sfx.play()
	GlobalInfo.full_screen = button_pressed


func _on_SFXSlider_value_changed(value: float) -> void:
	if is_visible_in_tree():
		options_sfx.play()
	GlobalInfo.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_MusicSlider_value_changed(value: float) -> void:
	if is_visible_in_tree():
		options_sfx.play()
	GlobalInfo.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
