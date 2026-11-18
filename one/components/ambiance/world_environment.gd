@tool
extends WorldEnvironment

const ENVIRONMENT_IN = preload("uid://voafri1olx3t")
const ENVIRONMENT_OUT = preload("uid://bd7e4eghm4cni")

@export var underwater_fog_gradient: Gradient

var under := false : set = _set_underwater


func _process(_delta: float) -> void:
	var viewport: Viewport
	
	if Engine.is_editor_hint():
		viewport = EditorInterface.get_editor_viewport_3d()
	else:
		viewport = get_viewport()
	
	if viewport == null: return
	
	var y_pos := viewport.get_camera_3d().global_position.y
	
	if under and y_pos >= 0.0:
		under = false
	elif not under and y_pos < 0.0:
		under = true
	
	if under:
		var alpha := inverse_lerp(0.0, -30.0, max(y_pos, -30.0))
		environment.fog_light_color = underwater_fog_gradient.sample(alpha)
		environment.fog_sky_affect = lerpf(.92, 1.0, alpha)


func _set_underwater(value: bool) -> void:
	under = value
	
	if under:
		environment = ENVIRONMENT_IN
	else:
		environment = ENVIRONMENT_OUT
