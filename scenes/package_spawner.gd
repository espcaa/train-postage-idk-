extends Node3D

var package_scene: PackedScene = preload("res://scenes/package.tscn")
@export var button: RigidBody3D

const PACKAGE_COLORS: Array[Color] = [
	Color(1.0, 0.2, 0.2),  # red
	Color(1.0, 0.85, 0.1),  # yellow
	Color(1.0, 0.5, 0.0),  # orange
	Color(0.2, 0.4, 1.0),  # blue
	Color(0.2, 0.8, 0.3),  # green
	Color(1.0, 0.4, 0.7),  # pink
	Color(0.6, 0.2, 0.9),  # purple
]


func _ready() -> void:
	if button:
		button.clicked.connect(spawn_package)
	else:
		print("PackageSpawner: No button assigned!")


func spawn_package() -> void:
	var new_instance = package_scene.instantiate()
	new_instance.package_color = PACKAGE_COLORS.pick_random()
	new_instance.call_deferred("add_to_group", "packages")
	add_child(new_instance)
