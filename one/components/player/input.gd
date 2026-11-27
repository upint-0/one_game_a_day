class_name PlayerInput
extends Node

const CHARGE_SPEED := 0.8

signal front_released

var front_strength := 0.0


func _process(delta: float) -> void:
	if Input.is_action_just_released("swim_front"):
		front_released.emit()
	
	if Input.is_action_pressed("swim_front"):
		front_strength += delta * CHARGE_SPEED
	else:
		front_strength = 0.0
	
	front_strength = clampf(front_strength, 0.0, 1.0)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.keycode == KEY_F11 and event.is_pressed() and not event.is_echo():
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
