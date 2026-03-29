extends CanvasLayer

var pickup_possible: bool = false


func _process(delta: float) -> void:
	$TopRight/PerfContainer/FPS.text = "Current fps: " + str(Engine.get_frames_per_second())
	if pickup_possible:
		$Center/CenterRight/Pickup.visible = true
	else:
		$Center/CenterRight/Pickup.visible = false
