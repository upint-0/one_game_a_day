class_name Rock
extends RigidBody3D

var target: Player = null

@onready var interactable: Interactable = %Interactable


func _ready() -> void:
	set_collision_layer_value(1, false)
	interactable.disable()
	await get_tree().process_frame
	scale = Vector3.ONE * pow(mass, 0.333)
	await get_tree().create_timer(3.0).timeout
	set_collision_layer_value(1, true)
	interactable.enable()


func _process(delta: float) -> void:
	if target == null: return
	
	global_position = target.global_position.lerp(global_position, exp(-4.0 * delta))


func _interacted(interactor: Node3D) -> void:
	target = interactor.owner


func pickup() -> void:
	target.inventory.weights.append(mass)
	queue_free()
