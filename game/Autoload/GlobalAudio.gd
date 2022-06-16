extends Node

onready var scene_change_sfx: AudioStreamPlayer = $SceneChange
onready var level_music: AudioStreamPlayer = $LevelMusic
onready var title_music: AudioStreamPlayer = $TitleMusic
onready var level_select_music: AudioStreamPlayer = $LevelSelectMusic

func play_change_scene_sfx() -> void:
	scene_change_sfx.play()

func change_music(music: String) -> void:
	match music:
		"title":
			level_music.stop()
			level_select_music.stop()
			title_music.play()
		"level":
			level_select_music.stop()
			title_music.stop()
			level_music.play()
		"level_select":
			level_music.stop()
			title_music.stop()
			level_select_music.play()
		"stop":
			level_music.stop()
			level_select_music.stop()
			title_music.stop()
