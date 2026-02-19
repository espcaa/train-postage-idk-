extends RigidBody3D

@export var package_color : Color 

func _ready() -> void:
	var mat = $package/Cube_003.get_active_material(0)
	
	if mat and mat.next_pass:
		mat.next_pass = mat.next_pass.duplicate()
		mat.next_pass.set_shader_parameter("tint_color", package_color)
