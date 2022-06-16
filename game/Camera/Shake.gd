extends Camera2D

export var decay := 0.9
export var max_offset := Vector2(50, 20)
export var max_roll = 0.1

var trauma := 0.0
var trauma_power := 2
var noise_y := 0.0

onready var noise := OpenSimplexNoise.new()

func _ready() -> void:
	Events.connect("shake_event_occured", self, "add_trauma")
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount) -> void:
	trauma = min(trauma + amount, 1.0)

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = 368 + max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = 288 + max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
