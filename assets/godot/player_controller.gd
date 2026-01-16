extends CharacterBody3D

const SPEED = 5.0
const ACCEL = 10.0
const JUMP_VELOCITY = 4.5

@export var MOUSE_SENSITIVITY: float = 0.1

var mouse_input := Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_input += event.relative


func _process(_delta):
	rotate_y(deg_to_rad(-mouse_input.x * MOUSE_SENSITIVITY))

	var camera = $Pivot/Camera3D
	camera.rotation.x -= deg_to_rad(mouse_input.y * MOUSE_SENSITIVITY)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	mouse_input = Vector2.ZERO


func _physics_process(delta: float) -> void:
	# gravity stuff \o/
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# physical movement
	var input_dir := Input.get_vector("left", "right", "forwards", "backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not is_on_floor():
		direction *= 0.3
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
