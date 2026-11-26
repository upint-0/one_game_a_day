class_name Rock
extends RigidBody3D

var target: Player = null


func _ready() -> void:
	await get_tree().process_frame
	scale = Vector3.ONE * pow(mass, 0.333)



func _process(delta: float) -> void:
	if target == null: return
	
	global_position = target.global_position.lerp(global_position, exp(-8.0 * delta))
	
	if global_position.distance_squared_to(target.global_position) < 0.1:
		pickup()
		target = null


func _interacted(interactor: Node3D) -> void:
	target = interactor.owner


func pickup() -> void:
	target.inventory.weights.append(mass)
	queue_free()
