extends CharacterBody3D

signal health_changed(current_health: int)

const MAX_HEALTH := 100
var health := MAX_HEALTH
var mental_health := 50.0
var inventory: Array[StringName] = []
var inventory_counts: Array[int] = []
var inventory_sources: Array[WeakRef] = []
var inventory_names: Array[String] = []
var aimed_door: Node3D
var aimed_pickup: Area3D
const PICKUP_DISTANCE := 2.5

@onready var flashlight: SpotLight3D = $Caretaker/RightShoulder/Elbow/Flashlight/Beam
@onready var camera: Camera3D = $Head/Camera3D
@onready var mental_health_bar: ProgressBar = $HealthHUD/MentalHealthBar
@onready var mental_health_label: Label = $HealthHUD/MentalHealthBar/MentalHealthLabel
@onready var pickup_prompt: Label = $HealthHUD/PickupPrompt

@onready var damage_sound: AudioStreamPlayer = $DamageSound
@onready var health_bar: ProgressBar = $HealthHUD/HealthBar
@onready var health_label: Label = $HealthHUD/HealthBar/HealthLabel
@onready var death_screen: Control = $HealthHUD/DeathScreen
@onready var retry_button: Button = $HealthHUD/DeathScreen/Content/Message/Retry

@export var walk_speed: float = 4.0
@export var sprint_speed: float = 7.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var ground_acceleration: float = 12.0
@export var air_acceleration: float = 3.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
const STEP_HEIGHT := 0.3
@onready var head: Node3D = $Head


func _ready() -> void:
	health_changed.connect(_update_health_display)
	retry_button.pressed.connect(_retry_level)
	_update_health_display(health)
	change_mental_health(0.0)
	add_inventory_item(&"flashlight", "Flashlight")
	_setup_input()
	floor_snap_length = 0.5  # keeps you glued to the ground going downhill
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func take_damage(amount: int) -> void:
	var remaining := clampi(health - amount, 0, MAX_HEALTH)
	if remaining != health:
		health = remaining
		health_changed.emit(health)
		if amount > 0:
			damage_sound.play()
		if health == 0:
			death_screen.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
			retry_button.grab_focus()


func _update_health_display(current_health: int) -> void:
	health_bar.value = current_health
	health_label.text = "HEALTH   %d / %d" % [current_health, MAX_HEALTH]


func _retry_level() -> void:
	var tree := get_tree()
	if tree.reload_current_scene() == OK:
		tree.paused = false


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
	_update_pickup_target()
	if _is_looking_at_baba_roga():
		change_mental_health(-2.0 * delta)
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

	# Step up onto stairs before moving
	var horizontal_motion := Vector3(velocity.x, 0.0, velocity.z) * delta
	try_step_up(horizontal_motion)

	move_and_slide()


func try_step_up(horizontal_motion: Vector3) -> void:
	if not is_on_floor():
		return
	if horizontal_motion.length() < 0.001:
		return

	# Blocked by something ahead at current height?
	if test_move(global_transform, horizontal_motion):
		# Is the path clear if we raise the body by STEP_HEIGHT?
		var raised := Transform3D(global_transform.basis,
			global_transform.origin + Vector3.UP * STEP_HEIGHT)
		if not test_move(raised, horizontal_motion):
			global_position.y += STEP_HEIGHT


func change_mental_health(amount: float) -> void:
	mental_health = clampf(mental_health + amount, 0.0, 100.0)
	mental_health_bar.value = mental_health
	mental_health_label.text = "MENTAL HEALTH   %.1f / 100" % mental_health


func has_inventory_item(item_id: StringName) -> bool:
	return item_id in inventory


func add_inventory_item(item_id: StringName, display_name: String, source: Node = null) -> bool:
	if inventory.size() >= 5:
		return false
	inventory.append(item_id)
	inventory_counts.append(20 if item_id == &"cigarette_box" else 1)
	inventory_sources.append(weakref(source))
	inventory_names.append(display_name)
	_refresh_inventory()
	return true


func consume_cigarette(slot: int = -1) -> bool:
	if slot == -1:
		slot = inventory.find(&"cigarette_box")
	if slot < 0 or slot >= inventory.size() or inventory[slot] != &"cigarette_box":
		return false
	inventory_counts[slot] -= 1
	if inventory_counts[slot] == 0:
		var source: Node = inventory_sources[slot].get_ref()
		inventory.remove_at(slot)
		inventory_counts.remove_at(slot)
		inventory_sources.remove_at(slot)
		inventory_names.remove_at(slot)
		if is_instance_valid(source):
			source.respawn()
	_refresh_inventory()
	return true


func _refresh_inventory() -> void:
	for i in 5:
		var slot := get_node("HealthHUD/Inventory/Slot%d" % (i + 1))
		var icon := slot.get_node("Icon") as TextureRect
		var count := slot.get_node("Item") as Label
		var occupied := i < inventory.size()
		icon.visible = occupied
		if occupied:
			match inventory[i]:
				&"cigarette_box":
					icon.texture = preload("res://Items/cigarette_box_icon.png")
				&"flashlight":
					icon.texture = preload("res://Items/flashlight_icon.png")
				&"battery":
					icon.texture = preload("res://Items/battery_icon.png")
				_:
					icon.visible = false
		count.text = str(inventory_counts[i]) if occupied else ""
		if occupied and inventory[i] == &"flashlight":
			count.text = "%d%%" % ceili(flashlight.battery)
		slot.tooltip_text = inventory_names[i] if occupied else ""


func _update_pickup_target() -> void:
	aimed_pickup = null
	aimed_door = null
	pickup_prompt.hide()
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var start := camera.global_position
	var query := PhysicsRayQueryParameters3D.create(start, start - camera.global_basis.z * PICKUP_DISTANCE, 129, [get_rid()])
	query.collide_with_areas = true
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return
	var target := hit.collider as Node
	if target.is_in_group("pickup"):
		aimed_pickup = target
		pickup_prompt.text = "press E"
		pickup_prompt.visible = inventory.size() < 5
		return
	while target:
		if target.is_in_group("interactable_door"):
			aimed_door = target
			pickup_prompt.text = "press E to close" if aimed_door.is_open else "press E to open"
			pickup_prompt.visible = not aimed_door.locked
			return
		target = target.get_parent()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode >= KEY_1 and event.physical_keycode <= KEY_5:
		var slot: int = event.physical_keycode - KEY_1
		if slot < inventory.size() and inventory[slot] != &"cigarette_box":
			use_inventory_slot(slot)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_E:
		_update_pickup_target()
		if is_instance_valid(aimed_pickup):
			aimed_pickup.collect(self)
			aimed_pickup = null
			pickup_prompt.hide()
			get_viewport().set_input_as_handled()
		elif is_instance_valid(aimed_door) and not aimed_door.locked:
			aimed_door.toggle()
			_update_pickup_target()
			get_viewport().set_input_as_handled()

func _is_looking_at_baba_roga() -> bool:
	if health == 0 or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return false
	var start := camera.global_position
	var query := PhysicsRayQueryParameters3D.create(start, start - camera.global_basis.z * camera.far, 1, [get_rid()])
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	return not hit.is_empty() and hit.collider.is_in_group("baba_roga")


func use_inventory_slot(slot: int) -> void:
	if slot < 0 or slot >= inventory.size():
		return
	match inventory[slot]:
		&"flashlight":
			flashlight.cycle_mode()
		&"battery":
			if flashlight.battery >= 100.0:
				return
			flashlight.recharge()
			var source: Node = inventory_sources[slot].get_ref()
			inventory.remove_at(slot)
			inventory_counts.remove_at(slot)
			inventory_sources.remove_at(slot)
			inventory_names.remove_at(slot)
			if is_instance_valid(source):
				source.queue_free()
			_refresh_inventory()