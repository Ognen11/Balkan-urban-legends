extends SpotLight3D

enum Mode { OFF, LOW, HIGH }

@onready var elbow: Node3D = get_parent().get_parent()
@onready var shoulder: Node3D = elbow.get_parent()
@onready var head: Node3D = owner.get_node("Head")
var mode := Mode.OFF
var raised := 0.0
var battery := 100.0
var displayed_battery := -1


func _ready() -> void:
	_set_mode(Mode.OFF)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.physical_keycode == KEY_F and event.pressed and not event.echo:
		cycle_mode()
		get_viewport().set_input_as_handled()


func cycle_mode() -> void:
	if not owner.has_inventory_item(&"flashlight") or battery <= 0.0:
		_set_mode(Mode.OFF)
		return
	_set_mode((mode + 1) % 3)


func _set_mode(next_mode: int) -> void:
	mode = next_mode as Mode
	visible = mode != Mode.OFF
	if visible:
		get_parent().show()
	light_energy = 4.5 if mode == Mode.HIGH else 1.8
	spot_range = 28.0 if mode == Mode.HIGH else 12.0
	spot_angle = 32.0 if mode == Mode.HIGH else 48.0
	if mode == Mode.OFF and raised == 0.0:
		get_parent().hide()


func recharge() -> void:
	battery = 100.0
	_update_battery_display()


func _update_battery_display() -> void:
	var percentage := ceili(battery)
	if percentage != displayed_battery:
		displayed_battery = percentage
		owner._refresh_inventory()


func _process(delta: float) -> void:
	if mode != Mode.OFF:
		var drain := 5.0 if mode == Mode.HIGH else 0.3
		battery = maxf(0.0, battery - drain * delta)
		if battery == 0.0:
			_set_mode(Mode.OFF)
	_update_battery_display()
	raised = move_toward(raised, 0.0 if mode == Mode.OFF else 1.0, delta * 3.0)
	var blend := smoothstep(0.0, 1.0, raised)
	shoulder.rotation.x = (deg_to_rad(80.0) + head.rotation.x) * blend
	elbow.rotation.x = lerpf(deg_to_rad(6.0), deg_to_rad(32.0), blend)
	if mode == Mode.OFF and raised == 0.0:
		get_parent().hide()
