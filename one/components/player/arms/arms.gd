extends Node3D

@onready var input: PlayerInput = %Input

# Targets
@onready var extended: Marker3D = %Extended
@onready var back: Marker3D = %Back

# IK
@onready var ik_l: Marker3D = %IK_L
@onready var ik_r: Marker3D = %IK_R


func _process(delta: float) -> void:
	var target_rotation := -15.0
	
	if input.front_strength > 0.0:
		ik_l.position = extended.position.lerp(ik_l.position, exp(-2.0*delta))
	else:
		ik_l.position = ik_l.position.move_toward(back.position, delta)
		target_rotation = 60.0
	
	target_rotation = deg_to_rad(target_rotation)
	
	ik_r.position = Vector3(-ik_l.position.x, ik_l.position.y, ik_l.position.z)
	ik_l.rotation.x = lerp_angle(target_rotation, ik_l.rotation.x, exp(-6.0*delta))
	ik_r.rotation.x = lerp_angle(target_rotation, ik_r.rotation.x, exp(-6.0*delta))
