extends CharacterBody3D

const SPEED = 5.0
const ACCEL = 10.0
const JUMP_VELOCITY = 4.5

const AIR_ACCEL = 3.0

@export var MOUSE_SENSITIVITY: float = 0.1

var mouse_input := Vector2.ZERO
var current_highlighted: PickableObject = null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative


func _process(_delta):
	var joy_input := Input.get_vector("look-left", "look-right", "look-up", "look-down")
	if joy_input != Vector2(0, 0):
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

	# picking stuff

	if $Pivot/Camera3D/RayCast3D.is_colliding():
		var collider = $Pivot/Camera3D/RayCast3D.get_collider()
		for i in collider.get_children():
			if i is PickableObject and i != current_highlighted:
				print(str(i) + " just lighted")
				i.highlight()
				current_highlighted = i
				break

		for obj in get_tree().get_nodes_in_group("pickable_objects"):
			if obj != collider and obj is PickableObject and obj != current_highlighted:
				print(str(obj) + " just unlighted")
				obj.unhighlight()
	else:
		for obj in get_tree().get_nodes_in_group("pickable_objects"):
			if obj is PickableObject and current_highlighted != null:
				print(str(obj) + " just unlighted")
				obj.unhighlight()
				if obj == current_highlighted:
					current_highlighted = null

	move_and_slide()
