extends VBoxContainer

signal level_selected

export var level := 1

var locked := true setget set_locked
var time_string := "Not Played!" setget set_time_string

onready var time_label: Label = $TimerLabel
onready var level_icon: TextureButton = $TextureButton

func _ready() -> void:
	set_locked(locked)
	set_time_string(time_string)


func set_locked(value: bool) -> void:
	locked = value
	level_icon.disabled = value


func set_time_string(value: String) -> void:
	time_string = value
	time_label.text = value


func _on_TextureButton_pressed() -> void:
	emit_signal("level_selected", level)
