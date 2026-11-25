extends Node3D

@export var open_angle_deg: float = 90.0
@export var open_time: float = 0.4
@export var interact_distance: float = 2.5
@export var locked: bool = false

@onready var pivot: Node3D = $Pivot

var is_open := false
var _tween: Tween
var _closed_y: float

func _ready() -> void:
	_closed_y = pivot.rotation.y

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if player == null:
		return
	var door_center := pivot.to_global(Vector3(0.5, 1.0, 0.0))
	var dist := door_center.distance_to(player.global_position)
	print("Door distance: ", dist)
	if dist <= interact_distance:
		toggle()

func toggle() -> void:
	if locked:
		return
	is_open = not is_open
	if _tween:
		_tween.kill()
	var target := _closed_y + deg_to_rad(open_angle_deg) if is_open else _closed_y
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(pivot, "rotation:y", target, open_time)
