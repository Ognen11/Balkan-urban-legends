extends Node3D

@export var open_angle_deg: float = 90.0
@export var open_time: float = 0.4
@export var interact_distance: float = 2.5
@export var locked: bool = false
@export var opening_clip: AudioStream
@export var closing_clip: AudioStream

@onready var pivot: Node3D = $Pivot
@onready var movement_sound := get_node_or_null("MovementSound") as AudioStreamPlayer3D

var is_open := false
var _tween: Tween
var _closed_y: float

func _ready() -> void:
	_closed_y = pivot.rotation.y
	add_to_group("interactable_door")

func toggle() -> void:
	if locked:
		return
	is_open = not is_open
	if movement_sound:
		movement_sound.stream = opening_clip if is_open else closing_clip
		if movement_sound.stream:
			movement_sound.play()
	if _tween:
		_tween.kill()
	var target := _closed_y + deg_to_rad(open_angle_deg) if is_open else _closed_y
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(pivot, "rotation:y", target, open_time)
