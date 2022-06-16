extends Control

onready var pause_sfx: AudioStreamPlayer = $PauseSFX
onready var anim_player: AnimationPlayer = $AnimationPlayer

func _on_Me_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))


func _on_Art_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))


func _on_Font_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))


func _on_Music_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
