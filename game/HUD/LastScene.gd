extends Control

var can_restart = false

onready var anim_player: AnimationPlayer = $AnimPlayer
onready var anim_scene: AnimationPlayer = $AnimScene

func _ready() -> void:
	GlobalAudio.change_music("stop")
	anim_scene.play("Start")
	anim_player.play("Idle")

func _unhandled_input(event: InputEvent) -> void:
	if can_restart and event.is_action_pressed("pause"):
		GlobalInfo.change_title_screen()

func _on_AnimScene_animation_finished(anim_name: String) -> void:
	if anim_name == "Start":
		anim_player.play("Win")
		anim_scene.play("TextAppear")
	elif anim_name == "TextAppear":
		can_restart = true
