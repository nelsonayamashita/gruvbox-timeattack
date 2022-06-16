extends MarginContainer

var num_grids := 2
var current_grid := 1
var grid_lenght := 467

onready var gridbox: HBoxContainer = $VBoxContainer/HBoxContainer/Clip/Gridbox
onready var shader: ColorRect = $Shader/CRT
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var back_button: TextureButton = $VBoxContainer/HBoxContainer/MarginContainer/Backbutton
onready var next_button: TextureButton = $VBoxContainer/HBoxContainer/MarginContainer2/NextButton

func _ready() -> void:
	shader.visible = GlobalInfo.using_shaddes
	
	anim_player.play("transition")
	
	GlobalAudio.change_music("level_select")
	GlobalInfo.clear_bullets()
	num_grids = gridbox.get_child_count()
	for grid in gridbox.get_children():
		for box in grid.get_children():
			if box.level <= GlobalInfo.unlocked_levels:
				box.locked = false
				box.time_string = GlobalInfo.level_time[box.get_name()]
			else:
				box.time_string = "Locked!"
			box.connect("level_selected", self, "_on_level_selected")


func _process(_delta: float) -> void:
	if current_grid == 1:
		back_button.visible = false
		next_button.visible = true
	elif current_grid == 2:
		back_button.visible = true
		next_button.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		GlobalInfo.change_title_screen()


func _on_Backbutton_pressed() -> void:
	if current_grid > 1:
		GlobalAudio.play_change_scene_sfx()
		current_grid -= 1
		gridbox.rect_position.x += grid_lenght
		anim_player.play("transition")


func _on_NextButton_pressed() -> void:
	if current_grid < num_grids:
		GlobalAudio.play_change_scene_sfx()
		current_grid += 1
		gridbox.rect_position.x -= grid_lenght
		anim_player.play("transition")


func _on_level_selected(level: int) -> void:
	GlobalAudio.play_change_scene_sfx()
	GlobalInfo.change_to_level(level)
	get_tree().change_scene(GlobalInfo.level_loader)
