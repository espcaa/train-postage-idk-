extends Area3D

var target_color: Color

func _ready() -> void:
	_apply_material()


func _apply_material() -> void:
	var col = target_color
	col.a = 0.55
	
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = col
	mat.emission_enabled = true
	mat.emission = target_color
	mat.emission_energy_multiplier = 0.4
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	$MeshInstance3D.material_override = mat


func flash_correct() -> void:
	var mat: StandardMaterial3D = $MeshInstance3D.material_override
	if not mat:
		return
	
	var tween = create_tween()
	tween.tween_property(mat, "emission_energy_multiplier", 3.0, 0.1)
	tween.tween_property(mat, "emission_energy_multiplier", 0.4, 0.4)
	
	var flash_tween = create_tween()
	var bright = target_color
	bright.a = 0.9
	var normal = target_color
	normal.a = 0.55
	flash_tween.tween_property(mat, "albedo_color", bright, 0.1)
	flash_tween.tween_property(mat, "albedo_color", normal, 0.4)
