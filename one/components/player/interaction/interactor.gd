class_name Interactor
extends Node3D

const RAY_LENGTH := 3.0

var current_target: Interactable
var results: Dictionary

@onready var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state


func _physics_process(_delta: float) -> void:
	_try_interact()
	
	if Input.is_action_just_pressed("swim_front") && current_target:
		current_target.interact(self)

 
func _try_interact() -> void:
	var from := global_position
	var to := from - global_basis.z * RAY_LENGTH
	
	var query := PhysicsRayQueryParameters3D.create(from, to, 4)
	query.collide_with_areas = true
	query.hit_from_inside = true
	query.collide_with_bodies = false
	results = space_state.intersect_ray(query)
	
	if !results.is_empty():
		var collider = results["collider"]
		if collider is Interactable:
			current_target = collider
	else:
		current_target = null


func can_interact() -> bool:
	return current_target != null
