class_name PlayerInput
extends Node

const CHARGE_SPEED := 2.0

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
