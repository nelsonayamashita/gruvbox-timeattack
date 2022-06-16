class_name StateMachine
extends Node

signal transitioned(state)

export var initial_state := NodePath()

onready var state: State = get_node(initial_state)

func _ready() -> void:
	# Godot tree structure starts init from its leaves to the root. This ensures
	# that the parent is initialized first.
	yield(owner, "ready")
	# Asigns itslef to all the states as the statemachine
	for child in get_children():
		child.state_machine = self
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func transition_to(target_state_name: String, msg := {}) -> void:
	assert(has_node(target_state_name), "State not found, maybe a typo?")
	
	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
