extends CanvasLayer

signal retry_pressed

var pickup_possible: bool = false

func _process(delta: float) -> void:
	$TopRight/PerfContainer/FPS.text = "Current fps: " + str(Engine.get_frames_per_second())
	$Center/CenterRight/Pickup.visible = pickup_possible

func update_score(score: int) -> void:
	$TopLeft/ScoreLabel.text = "Score: " + str(score)

func update_wave(wave: int) -> void:
	$TopLeft/WaveLabel.text = "Wave " + str(wave)

func set_orders(colors: Array[Color], current_index: int) -> void:
	var container = $TopCenter/OrdersContainer
	for child in container.get_children():
		child.queue_free()

	for i in range(current_index, colors.size()):
		if i == current_index:
			var arrow = Label.new()
			arrow.text = "->"
			arrow.add_theme_font_size_override("font_size", 40)
			arrow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			container.add_child(arrow)

		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(60, 60)
		rect.color = colors[i]
		container.add_child(rect)


func show_wave_banner(wave: int) -> void:
	var banner = $WaveBanner
	banner.text = "WAVE " + str(wave) + "!"
	banner.visible = true
	banner.modulate = Color(1, 1, 1, 0)
	banner.scale = Vector2(0.5, 0.5)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(banner, "modulate", Color(1, 1, 1, 1), 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(banner, "scale", Vector2(1.2, 1.2), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var tween2 = create_tween()
	tween2.tween_interval(1.5)
	tween2.tween_property(banner, "modulate", Color(1, 1, 1, 0), 0.5)
	tween2.tween_callback(func(): banner.visible = false)


func show_game_over(expected_name: String, expected_color: Color, score: int, wave: int) -> void:
	$Center.visible = false
	$TopCenter.visible = false
	$TopLeft.visible = false
	$GameOver.visible = true
	$GameOver/Panel/VBox/ExpectedLabel.text = "You should've done " + expected_name + "!"
	$GameOver/Panel/VBox/ExpectedColor.color = expected_color
	$GameOver/Panel/VBox/StatsLabel.text = "Score: " + str(score) + "  |  Wave: " + str(wave)


func _on_retry_button_pressed() -> void:
	retry_pressed.emit()
