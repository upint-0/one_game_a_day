class_name Water extends Area3D

@export var water_density := 125.0


var rigidbodies_in_water : Dictionary[RigidBody3D, Buoyancy]


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _physics_process(_delta: float) -> void:
	for rigidbody in rigidbodies_in_water:
		var buoyancy := rigidbodies_in_water[rigidbody]
		
		var depth : float
		
		for buoy in buoyancy.buoys:
			depth = global_position.y - (buoy.global_position.y-(buoyancy.diameter/2.0))
			depth = clampf(depth / buoyancy.diameter, 0.0, 1.0)
			
			# F = -pVg
			var force := -water_density * buoyancy.volume * depth * Vector3.DOWN * 9.8
			rigidbody.apply_force(force/buoyancy.buoys.size(), buoy.global_position - rigidbody.global_position)
		
		depth = global_position.y - (buoyancy.global_position.y-(buoyancy.diameter*0.5))
		depth = clampf(depth / buoyancy.diameter, 0.0, 1.0)
		
		rigidbody.linear_damp = 1.0 + depth
		rigidbody.angular_damp = 3.0 + depth * 5.0


func _on_body_entered(body : Node3D) -> void:
	var first_child := body.get_child(0)
	if body is RigidBody3D && !rigidbodies_in_water.has(body) && first_child is Buoyancy:
		var rb := body as RigidBody3D
		var buoyancy : Buoyancy = first_child
		rigidbodies_in_water[rb] = buoyancy
		if body.has_method("set_in_water"):
			@warning_ignore("unsafe_method_access")
			body.set_in_water(true)


func _on_body_exited(body : Node3D) -> void:
	if body is RigidBody3D && rigidbodies_in_water.has(body):
		var rb := body as RigidBody3D
		rb.linear_damp = 0.0
		rigidbodies_in_water.erase(rb)
		if body.has_method("set_in_water"):
			@warning_ignore("unsafe_method_access")
			body.set_in_water(false)
