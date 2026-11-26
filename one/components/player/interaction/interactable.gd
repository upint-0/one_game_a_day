class_name Interactable extends Area3D

signal interacted
signal interacted_with_source(interactor: Node3D)

var hovered := false


func _ready() -> void:
	process_physics_priority = 1


func _physics_process(_delta: float) -> void:
	hovered = false


func enable() -> void:
	set_collision_layer_value(3, true)
	monitorable = true


func disable() -> void:
	set_collision_layer_value(3, false)
	monitorable = false


func interact(interactor: Node3D) -> void:
	interacted.emit()
	interacted_with_source.emit(interactor)


func hover() -> void:
	hovered = true
