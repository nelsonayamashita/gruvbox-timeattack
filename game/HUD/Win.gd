extends Control

onready var time_label: Label = $MarginContainer/Elements/TimeLabel
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var win_sfx: AudioStreamPlayer = $WinSFX

func pop_up(time: float) -> void:
	anim_player.play("Pop")
	win_sfx.play()
	var mile := fmod(time, 1) * 100
	var seconds := fmod(time, 60)
	
	var time_string := "%02d.%02d" % [seconds, mile]
	
	time_label.text = time_string
	var float_time = float(time_string)
	var global_record = float(GlobalInfo.level_time[owner.owner.get_name()]) 
	if global_record == 0 or float_time < global_record:
		GlobalInfo.level_time[owner.owner.get_name()] = time_string
	
	GlobalInfo.save_game()


func disappear() -> void:
	anim_player.play("Disappear")


func _on_RestartButton_pressed() -> void:
	GlobalAudio.play_change_scene_sfx()
	GlobalInfo.restart()


func _on_NextButton_pressed() -> void:
	GlobalAudio.play_change_scene_sfx()
	GlobalInfo.next_level()
