extends RigidBody3D

var player: Player = null


func _physics_process(_delta: float) -> void:
	if player:
		player.global_position = global_position + Vector3.UP
		player.linear_velocity = Vector3.ZERO


func _on_plank_interacted_with_source(interactor: Node3D) -> void:
	if player:
		player.apply_central_impulse(Vector3(-player.global_basis.z.x, 1.0, -player.global_basis.z.z) * player.mass*5.0)
		player.swam.disconnect(_player_swam)
		player = null
	else:
		player = interactor.owner
		player.swam.connect(_player_swam)


func _player_swam(force: Vector3) -> void:
	apply_impulse(Vector3(force.x, 0.0, force.z).normalized() * 500.0, global_basis.z * 5.0)
