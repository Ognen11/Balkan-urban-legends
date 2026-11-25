extends CharacterBody3D

@export var walk_speed: float = 4.0
@export var sprint_speed: float = 7.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var ground_acceleration: float = 12.0
@export var air_acceleration: float = 3.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head: Node3D = $Head


func _ready() -> void:
	_setup_input()
	floor_snap_length = 0.5  # keeps you glued to the ground going downhill
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _setup_input() -> void:
	_add_key("move_forward", KEY_W)
	_add_key("move_back", KEY_S)
	_add_key("move_left", KEY_A)
	_add_key("move_right", KEY_D)
	_add_key("jump", KEY_SPACE)
	_add_key("sprint", KEY_SHIFT)


func _add_key(action: String, key: Key) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action)
	var ev := InputEventKey.new()
	ev.physical_keycode = key
	InputMap.action_add_event(action, ev)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85.0), deg_to_rad(85.0))

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Movement direction relative to where the player is facing
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	# Sprint only while moving forward
	var is_sprinting := Input.is_action_pressed("sprint") and input_dir.y < 0.0
	var target_speed := sprint_speed if is_sprinting else walk_speed

	var accel := ground_acceleration if is_on_floor() else air_acceleration
	var target_velocity := direction * target_speed
	velocity.x = move_toward(velocity.x, target_velocity.x, accel * delta * target_speed)
	velocity.z = move_toward(velocity.z, target_velocity.z, accel * delta * target_speed)

	move_and_slide()
