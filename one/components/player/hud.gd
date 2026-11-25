extends CanvasLayer

var current_air := 0.0

@onready var player: Player = owner

@onready var depth: Label = %Depth
@onready var air_left: ColorRect = %AirLeft
@onready var air_effect: ColorRect = %AirEffect
@onready var color_rect: ColorRect = $ColorRect
@onready var interactor: Interactor = $"../Camera3D/Interactor"


func _physics_process(delta: float) -> void:
	depth.text = str(snappedf(player.global_position.y, 0.1)) + "m"
	
	current_air = lerpf(player.air, current_air, exp(-4.0 * delta))
	air_left.scale.x = current_air
	(air_effect.material as ShaderMaterial).set_shader_parameter("fade", 1.0 - current_air)
	
	color_rect.visible = interactor.can_interact()
