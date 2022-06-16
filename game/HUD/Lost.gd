extends Control

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var lose_sfx: AudioStreamPlayer = $LoseSFX

func pop_up() -> void:
	lose_sfx.play()
	anim_player.play("Pop")


func disappear() -> void:
	anim_player.play("Disappear")


func _on_RestartButton_pressed() -> void:
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
