class_name PickableObject
extends Node3D

@export var highlighted_meshes: Array[MeshInstance3D] = []

func set_highlighted(highlighted: bool) -> void:
	for mesh in highlighted_meshes:
		if not mesh:
			continue
		
		if highlighted:
			mesh.show()
		else:
			mesh.hide()

func highlight() -> void:
	set_highlighted(true)

func unhighlight() -> void:
	set_highlighted(false)
