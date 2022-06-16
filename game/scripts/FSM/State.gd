class_name State
extends Node

# Reference to the state machine to call the `transistion_to()`
var state_machine = null

# ------ VIRTUAL METHODS -------

# Corresponds to `_unhandled_input` callback
func handle_input(_event: InputEvent) -> void:
	pass


# Corresponds to `_process()` callback
func update(_delta: float) -> void:
	pass


# Corresponds to `_physics_process` callback
func physics_update(_delta: float) -> void:
	pass


# Called when upon entering a state. A message can be passed as parameter to the 
# state. eg: jump impulse when changing from idle to air
func enter(_msg := {}) -> void:
	pass


# Called by state before changing the active state. Used to clean up the state.
func exit() -> void:
	pass

# ------------------------------
