extends Node3D

@export var distance: float = 2.2
@export var launch_speed: float = 0.2
@export var return_speed: float = 2.0

var _start_pos: Vector3
var _local_x: Vector3
var _tween: Tween
var launching = false


func _ready() -> void:
	_start_pos = $AnimatableBody3D.position
	_local_x = $AnimatableBody3D.transform.basis.x


func launch() -> void:
	if _tween and _tween.is_running():
		return

	var bodies_to_kick = $AnimatableBody3D/Area3D.get_overlapping_bodies()

	_tween = create_tween()
	var target_pos = _start_pos + (_local_x * distance)

	(
		_tween
		. tween_property($AnimatableBody3D, "position", target_pos, launch_speed)
		. set_trans(Tween.TRANS_EXPO)
		. set_ease(Tween.EASE_OUT)
	)

	var launch_velocity = _local_x * (distance / launch_speed)

	for body in bodies_to_kick:
		if body == $AnimatableBody3D:
			continue

		if body is RigidBody3D:
			body.apply_central_impulse(launch_velocity * body.mass)
		elif "velocity" in body:
			body.velocity += launch_velocity

	(
		_tween
		. tween_property($AnimatableBody3D, "position", _start_pos, return_speed)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN_OUT)
	)
