extends Node

func _ready() -> void:
	var level_num := str(GlobalInfo.current_level).pad_zeros(3)
	var path := "res://Levels/Level%s.tscn" % level_num
	var map = load(path).instance()
	
	add_child(map)
