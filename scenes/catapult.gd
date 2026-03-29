extends Node3D

@export var distance: float = 2.2
@export var launch_speed: float = 0.2
@export var return_speed: float = 2.0
@export var launch_force: float = 15.0
@export var button: RigidBody3D

var _start_pos: Vector3
var _local_x: Vector3
var _tween: Tween


func _ready() -> void:
	if button:
		button.clicked.connect(launch)
	else:
		print("akdjlqshgdkqsub")

	_start_pos = $Arm.position
	_local_x = $Arm.transform.basis.x


func launch() -> void:
	if _tween and _tween.is_running():
		return

	var bodies_to_kick = $LaunchZone.get_overlapping_bodies()
	var global_launch_dir = global_transform.basis * _local_x
	var launch_velocity = global_launch_dir * launch_force

	for body in bodies_to_kick:
		if body is RigidBody3D:
			body.apply_central_impulse(launch_velocity * body.mass)
		elif "velocity" in body:
			body.velocity += launch_velocity

	_tween = create_tween()
	var target_pos = _start_pos + (_local_x * distance)

	(
		_tween
		. tween_property($Arm, "position", target_pos, launch_speed)
		. set_trans(Tween.TRANS_EXPO)
		. set_ease(Tween.EASE_OUT)
	)

	(
		_tween
		. tween_property($Arm, "position", _start_pos, return_speed)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN_OUT)
	)
