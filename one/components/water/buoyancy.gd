@tool
## Add Maker3Ds as children for them to act like buoys
class_name Buoyancy extends Node3D

@export_tool_button("Estimate Volume") var estimate_button := _estimate_volume
@export var diameter : float
@export var volume : float


var buoys : Array[Node3D]


func _ready() -> void:
	buoys.clear()
	
	var children := get_children()
	
	if children.is_empty():
		buoys.append(self)
	else:
		for child in children:
			if child is Marker3D:
				buoys.append(child)


func _estimate_volume() -> void:
	volume = _calculate_visual_bounds(get_parent_node_3d()).get_volume()
	diameter = pow((volume*0.75)/PI, 0.3333333333333333)*2.0


func _calculate_visual_bounds(parent : Node3D) -> AABB:
	var bounds : AABB = AABB()
	if parent is MeshInstance3D:
		var visual_instance := parent as MeshInstance3D
		if visual_instance.custom_aabb.size != Vector3.ZERO:
			bounds = visual_instance.custom_aabb
		else:
			bounds = visual_instance.get_aabb();

	for i in range(parent.get_child_count()):
		if parent.get_child(i) is not Node3D: continue
		var child : Node3D = parent.get_child(i)
		if child:
			var child_bounds : AABB = _calculate_visual_bounds(child)
			if bounds.size == Vector3.ZERO && parent:
				bounds = child_bounds
			else:
				bounds = bounds.merge(child_bounds)
	return bounds
