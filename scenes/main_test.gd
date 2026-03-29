extends Node3D

@export var orders_per_wave: int = 3
@export var initial_target_speed: float = 10.0
@export var speed_increase_per_wave: float = 3.0
@export var targets_per_side: int = 10
@export var target_x_offset: float = 25.0
@export var target_spacing: float = 20.0
@export var target_y: float = 6.0

var score: int = 0
var wave: int = 1
var target_speed: float = 10.0
var game_active: bool = true

var wave_orders: Array[Color] = []
var current_order_index: int = 0

var target_block_scene: PackedScene = preload("res://scenes/target_block.tscn")
var active_targets: Array[Node] = []

const PACKAGE_COLORS: Array[Color] = [
	Color(1.0, 0.2, 0.2),    # red
	Color(1.0, 0.85, 0.1),   # yellow
	Color(1.0, 0.5, 0.0),    # orange
	Color(0.2, 0.4, 1.0),    # blue
	Color(0.2, 0.8, 0.3),    # green
	Color(1.0, 0.4, 0.7),    # pink
	Color(0.6, 0.2, 0.9),    # purple
]

const COLOR_NAMES: Dictionary = {
	Color(1.0, 0.2, 0.2): "Red",
	Color(1.0, 0.85, 0.1): "Yellow",
	Color(1.0, 0.5, 0.0): "Orange",
	Color(0.2, 0.4, 1.0): "Blue",
	Color(0.2, 0.8, 0.3): "Green",
	Color(1.0, 0.4, 0.7): "Pink",
	Color(0.6, 0.2, 0.9): "Purple",
}

@onready var hud = $PlayerController/Pivot/Camera3D/Hud


func _ready() -> void:
	target_speed = initial_target_speed
	_spawn_targets()
	_start_wave()
	hud.retry_pressed.connect(_on_retry)


func _process(delta: float) -> void:
	if not game_active:
		return

	_move_targets(delta)


func _start_wave() -> void:
	wave_orders.clear()
	current_order_index = 0
	for i in range(orders_per_wave):
		wave_orders.append(PACKAGE_COLORS.pick_random())
	hud.update_wave(wave)
	hud.update_score(score)
	hud.set_orders(wave_orders, current_order_index)


func _next_wave() -> void:
	wave += 1
	target_speed += speed_increase_per_wave
	hud.show_wave_banner(wave)
	_start_wave()


func _get_current_color() -> Color:
	return wave_orders[current_order_index]


func _game_over(wrong_color: Color) -> void:
	game_active = false
	var expected_name = COLOR_NAMES.get(_get_current_color(), "???")
	var expected_color = _get_current_color()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hud.show_game_over(expected_name, expected_color, score, wave)


func _on_retry() -> void:
	get_tree().reload_current_scene()


func _spawn_targets() -> void:
	for target in active_targets:
		if is_instance_valid(target):
			target.queue_free()
	active_targets.clear()

	for i in range(targets_per_side):
		var z_pos = -i * target_spacing

		var left = _create_target(Vector3(-target_x_offset, target_y, z_pos))
		active_targets.append(left)

		var right = _create_target(Vector3(target_x_offset, target_y, z_pos))
		active_targets.append(right)


func _create_target(pos: Vector3) -> Area3D:
	var target = target_block_scene.instantiate()
	target.target_color = PACKAGE_COLORS.pick_random()
	target.position = pos
	add_child(target)
	target.body_entered.connect(_on_target_body_entered.bind(target))
	return target


func _move_targets(delta: float) -> void:
	var loop_length = targets_per_side * target_spacing
	for target in active_targets:
		if not is_instance_valid(target):
			continue
		target.position.z += target_speed * delta
		if target.position.z > target_spacing + 40:
			target.position.z -= loop_length
			_recolor_target(target)


func _recolor_target(target: Area3D) -> void:
	target.target_color = PACKAGE_COLORS.pick_random()
	target._apply_material()


func _on_target_body_entered(body: Node3D, target: Area3D) -> void:
	if not body.is_in_group("packages"):
		return
	if not game_active:
		return

	var expected = _get_current_color()

	if body.package_color.is_equal_approx(target.target_color) and target.target_color.is_equal_approx(expected):
		target.flash_correct()
		score += 100
		current_order_index += 1
		hud.update_score(score)
		if current_order_index >= wave_orders.size():
			_next_wave()
		else:
			hud.set_orders(wave_orders, current_order_index)
	else:
		_game_over(body.package_color)
	body.die()


func _on_worldborder_body_entered(body: Node3D) -> void:
	if body.has_method("die"):
		body.die()
