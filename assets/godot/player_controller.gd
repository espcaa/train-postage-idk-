extends CharacterBody3D

const SPEED = 5.0
const ACCEL = 10.0
const JUMP_VELOCITY = 4.5

const AIR_ACCEL = 3.0

@export var MOUSE_SENSITIVITY: float = 0.1

var mouse_input := Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative
		print(mouse_input)

func _process(_delta):
	var joy_input := Input.get_vector("look-left", "look-right", "look-up", "look-down")
	if joy_input != Vector2(0,0):
		mouse_input = joy_input * 20.0
	_update_camera()
	

func _update_camera():
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
	var accel_to_use = ACCEL if is_on_floor() else AIR_ACCEL

	var input_dir := Input.get_vector("left", "right", "forwards", "backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, accel_to_use * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, accel_to_use * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED * delta * ACCEL)
			velocity.z = move_toward(velocity.z, 0, SPEED * delta * ACCEL)
		# If in air and no input, we don't add any friction (preserving momentum)

	move_and_slide()
