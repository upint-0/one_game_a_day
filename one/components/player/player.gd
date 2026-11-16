class_name Player
extends RigidBody3D

const FRONT_IMPULSE_STRENGTH := 333.0

const AIR_GAIN_RATE := 1.0
const AIR_LOSS_RATE := 0.01
const FRONT_IMPULSE_AIR_LOSS = 0.05

var air := 1.0:
	set(value):
		air = clampf(value, 0.0, 1.0)
var in_water := false

@onready var camera: Camera3D = %Camera3D
@onready var input: PlayerInput = %Input
@onready var buoyancy: Buoyancy = %Buoyancy
@onready var interactor: Interactor = %Interactor
@onready var inventory: Inventory = %Inventory


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	input.front_released.connect(_impule_front)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion: Vector2 = -event.xformed_by(get_tree().root.get_final_transform()).relative
		var torque := Vector3(motion.y, motion.x, 0.0)
		torque = global_basis * torque
		apply_torque(torque)


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
	buoyancy.volume = remap(depth, 0, 24.0, 0.5, 0.1)
	
	# Air
	if depth > 0:
		air -= delta * AIR_LOSS_RATE
	else:
		air += delta * AIR_GAIN_RATE


func _impule_front() -> void:
	if !in_water && interactor.can_interact(): return
	
	apply_central_impulse( -global_basis.z * input.front_strength * FRONT_IMPULSE_STRENGTH )
	air -= FRONT_IMPULSE_AIR_LOSS * input.front_strength


func set_in_water(value: bool) -> void:
	in_water = value
