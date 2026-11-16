extends Control

@export var animation_speed := 4.0
@onready var input: PlayerInput = %Input

## 0.0 is hidden, 0.5 is shown and 1.0 is hidden but completely open
var state := 0.0

func _ready() -> void:
	input.front_released.connect(func() -> void:
		create_tween().tween_method(_set_inner_radius, 1.0 - state, 0.0, 0.333)
		state = 0.0
		)


func _physics_process(_delta: float) -> void:
	if input.front_strength == 0.0: return
	
	state = input.front_strength * 0.9
	_set_inner_radius( 1.0 - state )
	scale = Vector2.ONE * lerpf(0.0, 1.0, state)


func _set_inner_radius(value: float) -> void:
	(material as ShaderMaterial).set_shader_parameter("inner_radius", value)
