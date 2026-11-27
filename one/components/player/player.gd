class_name Player
extends RigidBody3D

signal swam(force)

const FRONT_IMPULSE_STRENGTH := 900.0

const AIR_GAIN_RATE := 0.2
const AIR_LOSS_RATE := 0.005
const FRONT_IMPULSE_AIR_LOSS = 0.045

@export var force_over_time: Curve
@export var friction_over_time: Curve

var air := 1.0:
	set(value):
		air = clampf(value, 0.0, 1.0)
var in_water := false
var water_friction := 1.0

@onready var camera: Camera3D = %Camera3D
@onready var input: PlayerInput = %Input
@onready var buoyancy: Buoyancy = %Buoyancy
@onready var inventory: Inventory = %Inventory
@onready var last_breath: Timer = %LastBreath


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	input.front_released.connect(_impule_front)
	body_entered.connect(_on_body_entered)
	last_breath.timeout.connect(func() -> void:
		get_tree().paused = true
		%Drowned.show()
		await get_tree().create_timer(3.0, true, false, true).timeout
		get_tree().paused = false
		get_tree().reload_current_scene()
		)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion: Vector2 = -event.xformed_by(get_tree().root.get_final_transform()).relative
		var torque := Vector3(motion.y, motion.x, 0.0)
		torque = global_basis * torque
		apply_torque(torque)


func _process(delta: float) -> void:
	# Camera
	var target := lerpf(75.0, 80.0, input.front_strength)
	camera.fov = lerpf(target, camera.fov, exp(-8.0 * delta))


func _physics_process(delta: float) -> void:
	# Stay upright
	var axis = global_basis.z
	var angle = -global_rotation.z
	
	var torque = axis.normalized() * angle * 240.0
	torque -= angular_velocity
	
	apply_torque(torque)
	
	# Mass
	var additionnal_mass := 0.0
	
	for weight in inventory.weights:
		additionnal_mass += weight
	
	mass = 30.0 + additionnal_mass
	
	# Volume
	var depth := maxf(-camera.global_position.y, 0.0)
	depth = clampf(depth, 0.0, 48.0)
	buoyancy.volume = remap(depth, 0, 48.0, 0.45, 0.2)
	
	# Air
	if depth > 0:
		air -= delta * AIR_LOSS_RATE
	else:
		air += delta * AIR_GAIN_RATE
		last_breath.stop()
	
	air = clampf(air, 0.0, 1.0)
	
	if air == 0.0 && last_breath.is_stopped():
		last_breath.start()
		%Drown.play()


func _impule_front() -> void:
	air -= FRONT_IMPULSE_AIR_LOSS * max(input.front_strength, 0.66)
	
	var force :=  -global_basis.z * FRONT_IMPULSE_STRENGTH
	swam.emit(-global_basis.z * force)
	
	var t := create_tween()
	t.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	t.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	t.tween_method(func(value: float) -> void:
		linear_damp = water_friction * friction_over_time.sample(value)
		apply_central_force( -global_basis.z * force.length() * force_over_time.sample(value))
		, 0.0, 1.0, 
		input.front_strength)


func _on_body_entered(body: Node3D) -> void:
	if body is Rock:
		if body.target != null:
			body.pickup()


func set_in_water(value: bool) -> void:
	in_water = value
