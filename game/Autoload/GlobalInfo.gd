extends Node

var using_shaddes := true
var sfx_volume := -10.0
var music_volume := -10.0
var full_screen := OS.window_fullscreen setget set_fullscreen
var current_level := 0
var unlocked_levels := 0
var num_levels := 23
var level_loader := "res://Autoload/LevelLoader/LevelLoader.tscn"
var level_menu := "res://HUD/LevelSelect/LevelMenu.tscn"
var title_screen := "res://HUD/TitleScreen.tscn"
var last_scene := "res://HUD/LastScene.tscn"

var level_time: Dictionary = {
	"sfx_volume": -10.0,
	"music_volume": -10.0,
	"unlocked_levels": 0,
	"Level000": "Not Played!",
	"Level001": "Not Played!",
	"Level002": "Not Played!",
	"Level003": "Not Played!",
	"Level004": "Not Played!",
	"Level005": "Not Played!",
	"Level006": "Not Played!",
	"Level007": "Not Played!",
	"Level008": "Not Played!",
	"Level009": "Not Played!",
	"Level010": "Not Played!",
	"Level011": "Not Played!",
	"Level012": "Not Played!",
	"Level013": "Not Played!",
	"Level014": "Not Played!",
	"Level015": "Not Played!",
	"Level016": "Not Played!",
	"Level017": "Not Played!",
	"Level018": "Not Played!",
	"Level019": "Not Played!",
	"Level020": "Not Played!",
	"Level021": "Not Played!",
	"Level022": "Not Played!",
	"Level023": "Not Played!",
	"Level024": "Not Played!",
	"Level025": "Not Played!",
	"Level026": "Not Played!",
	"Level027": "Not Played!",
	"Level028": "Not Played!",
	"Level029": "Not Played!",
	"Level030": "Not Played!",
	"Level031": "Not Played!"
}

# EXPORT UNCOMMENT
func _ready() -> void:
	load_game()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)


func restart() -> void:
	var current_tree := get_tree()
	current_tree.paused = false
	current_tree.reload_current_scene()
	
	clear_bullets()


func change_title_screen() -> void:
	get_tree().change_scene(title_screen)


func change_level_menu() -> void:
	get_tree().change_scene(level_menu)


func change_to_level(num_level: int) -> void:
	current_level = num_level


func next_level() -> void:
	current_level += 1
	if current_level <= num_levels:
		restart()
	else:
		current_level = 1
		get_tree().paused = false
		get_tree().change_scene(last_scene)


func set_fullscreen(value: bool) -> void:
	OS.window_fullscreen = value
	full_screen = value


func clear_bullets() -> void:
	for bullet in Projectiles.get_children():
		bullet.queue_free()


func save_game():
	level_time["unlocked_levels"] = unlocked_levels
	level_time["sfx_volume"] = sfx_volume
	level_time["music_volume"] = music_volume
	var path:= "user://gruvbox_data.res"
	var password := "eusoucornopracaralhoenaoqueroquedescrubamqualehoarquivo1308"
	var file := File.new()
	file.open_encrypted_with_pass(path, File.WRITE, password)
	file.store_string(to_json(level_time))
	file.close()


func load_game():
	var password := "eusoucornopracaralhoenaoqueroquedescrubamqualehoarquivo1308"
	var path:= "user://gruvbox_data.res"
	var file = File.new()
	if file.file_exists(path):
		file.open_encrypted_with_pass(path , File.READ, password)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			level_time = data
			unlocked_levels = level_time["unlocked_levels"]
			sfx_volume = level_time["sfx_volume"]
			music_volume = level_time["music_volume"]
		else:
			printerr("Corupted data!")
