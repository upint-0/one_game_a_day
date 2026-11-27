class_name Inventory
extends Node

const ROCK = preload("uid://bn7wsg1phjl7d")
const RING = preload("uid://8cdxjvqklac5")

var weights: Array[float]

@onready var interactor: Interactor = $"../Camera3D/Interactor"


func _physics_process(_delta: float) -> void:
	# Drop rocks
	if Input.is_action_just_pressed("drop") and not weights.is_empty():
		var weight: float = weights.pop_back()
		var instance: Rock = ROCK.instantiate() if weight != 1.0 else RING.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.mass = weight
		var player: Player = owner
		instance.global_position = player.global_position - player.global_basis.z
