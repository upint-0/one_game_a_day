class_name Highlight
extends Node

@export var mesh: MeshInstance3D

@onready var parent: Interactable = get_parent()


func _physics_process(_delta: float) -> void:
	(mesh.material_overlay as StandardMaterial3D).albedo_color.a = 0.1 if parent.hovered else 0.0
