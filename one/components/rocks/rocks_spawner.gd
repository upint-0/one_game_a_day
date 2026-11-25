extends Node3D

const ROCK = preload("uid://bn7wsg1phjl7d")

const SPAWN_RADIUS = 32.0


func _ready() -> void:
	await get_tree().process_frame
	
	for i in 100:
		var instance: Node3D = ROCK.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position.x = randf_range(-SPAWN_RADIUS, SPAWN_RADIUS)
		instance.position.y = -3.0
		instance.position.z = randf_range(-SPAWN_RADIUS, SPAWN_RADIUS)
		instance.rotation.y = randf() * TAU
		instance.mass = randf_range(1.0, 4.0)
		
		await get_tree().process_frame
