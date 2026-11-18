extends RigidBody3D

var target: Player = null


func _process(delta: float) -> void:
	if target == null: return
	
	global_position = target.global_position.lerp(global_position, exp(-4.0 * delta))
	
	if global_position.distance_squared_to(target.global_position) > 0.333:
		target.inventory.weights.append(mass)
		queue_free()


func _on_interacted(interactor: Node3D) -> void:
	target = interactor.owner
