extends Node3D

const SPAWN_RADIUS = 32.0


func _ready() -> void:
	for i in 100:
		var instance: Node3D = Dealer.ROCK_MEDIUM.instantiate() if randf() > 0.5 else Dealer.ROCK_SMALL.instantiate()
		add_child(instance)
		instance.position.x = randf_range(-SPAWN_RADIUS, SPAWN_RADIUS)
		instance.position.y = 0.0
		instance.position.z = randf_range(-SPAWN_RADIUS, SPAWN_RADIUS)
		instance.rotation.y = randf() * TAU
		
		await get_tree().process_frame
