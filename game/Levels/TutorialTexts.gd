extends Control

var move_text_shown := false
var shoot_text_shown := false
var bullet_text_shown := false
var dash_text_shown := false
var win_text_shown := false
var air_text_shown := false

onready var anim_player: AnimationPlayer = $AnimationPlayer

func _on_ShootTrigger_body_entered(body: Node) -> void:
	if not move_text_shown:
		move_text_shown = true
		anim_player.play("t1")

func _on_BulletTrigger_body_entered(body: Node) -> void:
	if not shoot_text_shown:
		shoot_text_shown = true
		anim_player.play("t2")


func _on_DashTrigger_body_entered(body: Node) -> void:
	if not dash_text_shown:
		dash_text_shown = true
		anim_player.play("t3")


func _on_WinTrigger_body_entered(body: Node) -> void:
	if not win_text_shown:
		win_text_shown = true
		anim_player.play("t4")


func _on_AirTrigger_body_entered(body: Node) -> void:
	if not air_text_shown:
		air_text_shown = true
		anim_player.play("t5")
