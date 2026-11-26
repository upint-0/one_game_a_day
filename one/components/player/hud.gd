extends CanvasLayer

var current_air := 0.0

@onready var player: Player = owner

@onready var depth: Label = %Depth
@onready var mass: Label = %Mass
@onready var air_left: ColorRect = %AirLeft
@onready var air_effect: ColorRect = %AirEffect
@onready var fade: ColorRect = %Fade
@onready var interactor: Interactor = %Interactor
@onready var f: Label = %F


func _ready() -> void:
	set_physics_process(false)
	fade.color.a = 1.0
	var t := create_tween()
	t.tween_interval(2.0)
	t.tween_property(fade, "color:a", 0.0, 3.0)
	await t.finished
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	depth.text = str(snappedf(player.global_position.y, 0.1)) + "m"
	mass.text = str(snappedf(player.mass - 30.0, 0.1)) + "kg"
	
	current_air = lerpf(player.air, current_air, exp(-4.0 * delta))
	air_left.scale.x = current_air
	(air_effect.material as ShaderMaterial).set_shader_parameter("fade", 1.0 - current_air)
	
	var last_breath := 1.0 - (player.last_breath.time_left / player.last_breath.wait_time)
	
	if last_breath == 1.0:
		fade.color.a = 0.0
	else:
		fade.color.a = last_breath
	
	f.visible = interactor.can_interact()
