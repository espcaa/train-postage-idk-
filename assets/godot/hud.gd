extends CanvasLayer

func _process(delta: float) -> void:
	$TopRight/PerfContainer/FPS.text = "Current fps: "+str(Engine.get_frames_per_second())
