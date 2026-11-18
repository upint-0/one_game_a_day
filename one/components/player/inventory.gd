class_name Inventory
extends Node

var weights: Array[float]


func _physics_process(_delta: float) -> void:
	# Drop rocks
	if not weights.is_empty():
		var weight: float = weights.pick_random()
		weights.erase(weight)
		var instance: Node3D = Dealer.ROCK_SMALL.instantiate() if weight < 2.0 else Dealer.ROCK_MEDIUM.instantiate()
		get_tree().add_child(instance)
		var player: Player = owner
		instance.global_position = player.global_position - player.global_basis.z
