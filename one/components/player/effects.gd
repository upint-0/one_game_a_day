extends Node3D

@onready var input: PlayerInput = %Input
@onready var bubbles: GPUParticles3D = %Bubbles


func _ready() -> void:
	input.front_released.connect(_on_front_released)


func _on_front_released() -> void:
	var force := input.front_strength
	bubbles.amount = int(lerpf(1.0, 8.0, force))
	bubbles.speed_scale = lerpf(3.0, 1.4, force)
	bubbles.emitting = true
