extends Node3D

var package_scene: PackedScene = preload("res://scenes/package.tscn")


func spawn_package():
	var new_instance = package_scene.instantiate()
	new_instance.call_deferred("add_to_group", "packages")
	add_child(new_instance)
