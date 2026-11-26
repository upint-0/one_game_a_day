class_name Interactor
extends Node3D

const RAY_LENGTH := 3.0

var current_target: Interactable
var results: Dictionary

@onready var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state


func _physics_process(_delta: float) -> void:
	_try_interact()
	
	if current_target == null: return
	
	current_target.hover()
	
	if Input.is_action_just_pressed("interact"):
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
		var collider: Node3D = results["collider"]
		if collider is Interactable:
			current_target = collider
	elif current_target != null:
		current_target = null


func can_interact() -> bool:
	return current_target != null
