extends Node3D

@onready var input: PlayerInput = %Input
@onready var bubbles: GPUParticles3D = %Bubbles


func _ready() -> void:
	input.front_released.connect(_on_front_released)
	_on_front_released()


func _on_front_released() -> void:
	if global_position.y > 0.0: return
	
	var effect := _get_effect()
	var force := input.front_strength
	effect.amount = int(lerpf(1.0, 8.0, force))
	effect.speed_scale = lerpf(3.0, 1.4, force)
	effect.emitting = true


func _get_effect() -> GPUParticles3D:
	for child in get_children():
		if child is GPUParticles3D:
			if child.emitting:
				continue
			else:
				return child
	
	var new_effect: GPUParticles3D = get_child(0).duplicate()
	add_child(new_effect)
	return new_effect
