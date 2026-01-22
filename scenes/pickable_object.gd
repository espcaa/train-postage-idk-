class_name PickableObject
extends Node3D

@export var highlighted_meshes: Array[MeshInstance3D] = []
var outline_material: StandardMaterial3D


func _ready() -> void:
	outline_material = StandardMaterial3D.new()
	outline_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	outline_material.albedo_color = Color(1, 1, 0)  # Yellow
	outline_material.cull_mode = BaseMaterial3D.CULL_FRONT
	outline_material.grow = true
	outline_material.grow_amount = 0.03

	outline_material.stencil_mode = BaseMaterial3D.STENCIL_MODE_CUSTOM
	outline_material.stencil_compare = BaseMaterial3D.STENCIL_COMPARE_NOT_EQUAL
	outline_material.stencil_reference = 1


func set_highlighted(highlighted: bool) -> void:
	for mesh in highlighted_meshes:
		if not mesh:
			continue

		var base_mat = mesh.get_active_material(0)

		if highlighted:
			if base_mat:
				base_mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_CUSTOM
				base_mat.stencil_flags = BaseMaterial3D.STENCIL_FLAG_WRITE
				base_mat.stencil_reference = 1

			mesh.material_overlay = outline_material
		else:
			# Clean up
			if base_mat:
				base_mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
			mesh.material_overlay = null


func highlight() -> void:
	set_highlighted(true)


func unhighlight() -> void:
	set_highlighted(false)
