extends SpotLight3D

@export_group("Low Beam")
@export var low_energy: float = 1.8
@export var low_range: float = 12.0
@export var low_angle: float = 48.0

@export_group("High Beam")
@export var high_energy: float = 4.5
@export var high_range: float = 28.0
@export var high_angle: float = 32.0

var _high_beam := false


func _ready() -> void:
	_apply_beam()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return

	match event.physical_keycode:
		KEY_L:
			visible = not visible
		KEY_O:
			_high_beam = not _high_beam
			_apply_beam()
		_:
			return

	get_viewport().set_input_as_handled()


func _apply_beam() -> void:
	light_energy = high_energy if _high_beam else low_energy
	spot_range = high_range if _high_beam else low_range
	spot_angle = high_angle if _high_beam else low_angle
