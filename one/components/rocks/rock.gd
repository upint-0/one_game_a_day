extends RigidBody3D


func _on_interacted(interactor: Interactor) -> void:
	(interactor.owner as Player).inventory.weights.append(mass)
	queue_free()
