class_name PickableObject
extends Node3D

@export var highlighted_meshes: Array[MeshInstance3D] = []

var outline_material: StandardMaterial3D

func _ready() -> void:
	outline_material = StandardMaterial3D.new()
	outline_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	outline_material.albedo_color = Color(1, 1, 1, 0.1)  # white is better
	outline_material.grow = true
	outline_material.grow_amount = 0.02
	outline_material.render_priority = 100

func set_highlighted(highlighted: bool) -> void:
	for mesh in highlighted_meshes:
		if not mesh:
			continue

		var base_mat: BaseMaterial3D = mesh.get_active_material(0)

		if highlighted:
			if base_mat:
				base_mat.stencil_enabled = true
				base_mat.stencil_comparison = BaseMaterial3D.STENCIL_FLAG_WRITE
				base_mat.stencil_reference = 1
				base_mat.stencil_pass = BaseMaterial3D.STENCIL_FLAG_WRITE
			mesh.material_override = outline_material
		else:
			if base_mat:
				base_mat.stencil_enabled = false
			mesh.material_override = null

func highlight() -> void:
	set_highlighted(true)

func unhighlight() -> void:
	set_highlighted(false)
