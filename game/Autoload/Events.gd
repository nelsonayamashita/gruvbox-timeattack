extends Node

# Player Dash Cooldown update -> Dash HUD
signal dash_cooldown_changed(time_left)
# Player can_shoot_var update -> Ammo HUD
signal can_shoot_changed(value)
# Pause menu -> Level FSM, kinda messy
signal pause_event_pressed
# Player NoControl -> HUD (win, lose)
signal no_control_animation_ended(anim)
# Ready to start timer
signal player_ready
# Any enemy died -> Player can_canshot var = true
signal enemy_died
# Menu -> Global Configs
signal shader_changed_visibility(button_pressed) 
# player shake event -> camera
signal shake_event_occured(amount)

