extends Node3D


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("spawn_package"):
		$package_spawner.spawn_package()


func _on_worldborder_body_entered(body: Node3D) -> void:
	if body.has_method("die"):
		body.die()
