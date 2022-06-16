extends Control

var is_in_options = false
var is_in_license = false

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var shader: ColorRect = $Shader/CRT
onready var options: Control = $Options
onready var credits: Control = $Credits

func _ready() -> void:
	shader.visible = GlobalInfo.using_shaddes
	anim_player.play("transition")
	
	GlobalAudio.change_music("title")
	GlobalInfo.clear_bullets()
	Events.connect("shader_changed_visibility", self, "_on_shadder_changed_visibility")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_in_options:
			is_in_options = false
			options.pause_sfx.play()
			options.anim_player.play("Disappear")
		elif is_in_license:
			is_in_license = false
			credits.pause_sfx.play()
			credits.anim_player.play("Disappear")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "transition":
		anim_player.play("Start")
	if anim_name == "Start":
		anim_player.play("Idle")


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Options_pressed() -> void:
	if not is_in_options:
		is_in_options = true
		options.pause_sfx.play()
		options.anim_player.play("Pop")

func _on_shadder_changed_visibility(value: bool) -> void:
	shader.visible = value
	GlobalInfo.using_shaddes = value


func _on_Level_pressed() -> void:
	GlobalAudio.play_change_scene_sfx()
	get_tree().change_scene(GlobalInfo.level_menu)


func _on_License_pressed() -> void:
	if not is_in_license:
		is_in_license = true
		credits.pause_sfx.play()
		credits.anim_player.play("Pop")
