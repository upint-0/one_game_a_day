class_name Interactable extends Area3D

signal interacted
signal interacted_with_source(interactor: Interactor)


func enable() -> void:
	set_collision_layer_value(3, true)
	monitorable = true


func disable() -> void:
	set_collision_layer_value(3, false)
	monitorable = false


func interact(interactor: Interactor) -> void:
	interacted.emit()
	interacted_with_source.emit(interactor)
