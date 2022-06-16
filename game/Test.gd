extends Node2D

signal win()

onready var enemies: Node = $Enemies
onready var player: Player = $Player

func _ready() -> void:
	for enemy in $Enemies.get_children():
		if enemy.is_in_group("chaser"):
			enemy.target = player


func _process(delta: float) -> void:
	if enemies.get_child_count() == 0:
		emit_signal("win")
