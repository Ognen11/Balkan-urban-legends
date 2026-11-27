extends Node3D

const REST := Vector3(-0.30, -0.56, -0.44)
const RELAXED := [Vector3(0.18, 0.28, 0.16), Vector3(0.14, 0.24, 0.15), Vector3(0.10, 0.18, 0.10), Vector3(0.08, 0.16, 0.10), Vector3(0.16, 0.12, 0.08)]
# Little, ring, middle, index, thumb. Each entry contains the three joint bends.
const LIKE := [Vector3(1.12, 1.58, 0.90), Vector3(1.15, 1.62, 0.92), Vector3(1.12, 1.60, 0.88), Vector3(1.08, 1.54, 0.82), Vector3(0.03, 0.08, 0.04)]
const MIDDLE := [Vector3(1.06, 1.62, 0.95), Vector3(1.10, 1.65, 0.92), Vector3(0.04, 0.04, 0.06), Vector3(1.10, 1.60, 0.90), Vector3(0.12, 0.18, 0.12)]
const SMOKE := [Vector3(1.16, 1.55, 0.85), Vector3(1.03, 1.50, 0.83), Vector3(0.15, 0.20, 0.10), Vector3(0.08, 0.14, 0.08), Vector3(0.25, 0.48, 0.25)]
const GRIP := [Vector3(0.82, 1.32, 0.78), Vector3(0.86, 1.36, 0.78), Vector3(0.88, 1.32, 0.74), Vector3(0.78, 1.26, 0.68), Vector3(0.72, 0.55, 0.30)]
const DIGITS := ["Little", "Ring", "Middle", "Index", "Thumb"]

@onready var hand: Node3D = $Hand
@onready var body_arm: Node3D = owner.get_node("Caretaker/LeftShoulder")
@onready var right_arm: Node3D = owner.get_node("Caretaker/RightShoulder")
@onready var skeleton: Skeleton3D = $Hand/Anatomy.find_children("*", "Skeleton3D", true, false)[0]
@onready var pack: Node3D = $Hand/Pack
@onready var cigarette: Node3D = $Hand/Cigarette
@onready var lit_tip: Node3D = $Hand/Cigarette/LitTip
@onready var tip_smoke: CPUParticles3D = $Hand/Cigarette/TipSmoke
@onready var lighter: Node3D = $Hand/Lighter
@onready var flame: Node3D = $Hand/Lighter/Flame
@onready var exhale_smoke: CPUParticles3D = $Exhale

var sequence: Tween
var right_hand: Node3D
var right_skeleton: Skeleton3D
var pose: Array = RELAXED.duplicate()
var thumb_swing := 0.0
var right_was_visible := true
var right_borrowed := false
var flame_time := 0.0
var mental_health_reward := 0.0


func _ready() -> void:
	var skin_mesh: MeshInstance3D = $Hand/Anatomy.find_child("Left hand", true, false)
	var skin := skin_mesh.get_active_material(0) as StandardMaterial3D
	skin.vertex_color_use_as_albedo = true
	right_hand = Node3D.new()
	right_hand.name = "LightingHand"
	add_child(right_hand)
	var anatomy := $Hand/Anatomy.duplicate()
	right_hand.add_child(anatomy)
	anatomy.scale.x = -1.0
	right_skeleton = anatomy.find_children("*", "Skeleton3D", true, false)[0]
	var sleeve := $Hand/CanvasSleeve.duplicate()
	right_hand.add_child(sleeve)
	var cuff := $Hand/Cuff.duplicate()
	if cuff:
		right_hand.add_child(cuff)
	for part in find_children("*", "MeshInstance3D", true, false):
		part.layers = 4
		part.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	right_hand.hide()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if sequence and sequence.is_valid() and sequence.is_running():
		return
	match event.physical_keycode:
		KEY_F1:
			mental_health_reward = 0.1
			_gesture(LIKE, 0.85, (Basis(Vector3.BACK, deg_to_rad(-90.0)) * Basis.from_euler(Vector3(0.10, -0.45, 0.0))).get_euler())
		KEY_F2:
			mental_health_reward = -0.1
			_gesture(MIDDLE, 0.08, Vector3(0.08, -0.48, -0.55))
		KEY_1, KEY_2, KEY_3, KEY_4, KEY_5:
			var slot: int = event.physical_keycode - KEY_1
			if not owner.consume_cigarette(slot):
				return
			mental_health_reward = 20.0
			_smoke_cigarette()
		_:
			return
	get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if flame.is_visible_in_tree():
		flame_time += delta
		flame.scale = Vector3(1, 0.95 + 0.13 * sin(flame_time * 41), 1)


func _begin() -> void:
	if sequence and sequence.is_valid():
		sequence.kill()
	_cleanup()
	body_arm.hide()
	hand.show()
	hand.position = REST
	hand.rotation = Vector3(0.1, -0.3, -0.15)
	_apply_pose(RELAXED, 0.0)
	sequence = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sequence.finished.connect(_finish)


func _gesture(target: Array, swing: float, rotation_target: Vector3) -> void:
	_begin()
	_move(hand, Vector3(-0.19, -0.235, -0.48), rotation_target, 0.36)
	_animate_pose(target, swing, 0.30)
	sequence.tween_interval(1.15)
	_move(hand, Vector3(-0.185, -0.232, -0.478), rotation_target + Vector3(0.025, 0.035, 0.015), 0.25)
	_lower()


func _smoke_cigarette() -> void:
	_begin()
	pack.show()
	_apply_pose(GRIP, -0.80)
	_move(hand, Vector3(-0.20, -0.25, -0.46), Vector3(0.08, -0.35, -0.18), 0.42)
	sequence.tween_interval(0.6)
	_move(hand, Vector3(-0.27, -0.43, -0.40), Vector3(0.12, -0.25, -0.25), 0.30)
	sequence.tween_callback(_prepare_lighting)
	_move(hand, Vector3(-0.19, -0.20, -0.43), Vector3(0.02, 0.08, -1.10), 0.48)
	sequence.parallel().tween_property(right_hand, "position", Vector3(0.054, -0.250, -0.43), 0.48)
	sequence.tween_callback(flame.show)
	sequence.tween_interval(0.65)
	sequence.tween_callback(_ignite)
	sequence.tween_property(right_hand, "position", Vector3(0.30, -0.55, -0.38), 0.38)
	sequence.tween_callback(_hide_right)
	for drag in 2:
		_move(hand, Vector3(-0.12, -0.17, -0.22), Vector3(-0.18, 0.16, -1.0), 0.48)
		sequence.tween_callback(_draw_ember)
		sequence.tween_interval(0.65)
		_move(hand, Vector3(-0.23, -0.26, -0.43), Vector3(0.08, -0.12, -0.92), 0.50)
		sequence.tween_callback(_exhale)
		sequence.tween_interval(1.05)
	_lower()


func _prepare_lighting() -> void:
	pack.hide()
	cigarette.show()
	_apply_pose(SMOKE, -0.18)
	# The reference holds the cigarette between index and middle finger.
	cigarette.position = Vector3(-0.019, 0.150, 0.023)
	cigarette.rotation = Vector3(PI / 2.0, 0, 0)
	right_was_visible = right_arm.visible
	right_borrowed = true
	right_arm.hide()
	right_hand.position = Vector3(0.30, -0.55, -0.38)
	right_hand.rotation = Vector3(0.05, -0.25, 0.18)
	right_hand.show()
	lighter.reparent(right_hand, false)
	lighter.position = Vector3(0.005, 0.15, 0.055)
	lighter.rotation = Vector3.ZERO
	lighter.show()
	_set_rig_pose(right_skeleton, GRIP, -0.80)


func _move(node: Node3D, target: Vector3, turn: Vector3, duration: float) -> void:
	sequence.tween_property(node, "position", target, duration)
	sequence.parallel().tween_property(node, "rotation", turn, duration)


func _animate_pose(target: Array, swing: float, duration: float) -> void:
	var source := pose.duplicate()
	var source_swing := thumb_swing
	sequence.parallel().tween_method(func(weight: float):
		var blended: Array = []
		for i in 5:
			blended.append(source[i].lerp(target[i], weight))
		_apply_pose(blended, lerpf(source_swing, swing, weight))
	, 0.0, 1.0, duration)


func _apply_pose(target: Array, swing: float) -> void:
	pose = target.duplicate()
	thumb_swing = swing
	_set_rig_pose(skeleton, target, swing)


func _set_rig_pose(rig: Skeleton3D, target: Array, swing: float) -> void:
	for i in 5:
		for joint in 3:
			var turn := Quaternion(Vector3.RIGHT, target[i][joint])
			if i == 4 and joint == 0:
				turn *= Quaternion(Vector3.BACK, swing)
			var index := rig.find_bone(DIGITS[i] + str(joint))
			var parent := rig.get_bone_parent(index)
			var axes := rig.get_bone_global_rest(parent).basis.get_rotation_quaternion()
			var rest := rig.get_bone_rest(index).basis.get_rotation_quaternion()
			rig.set_bone_pose_rotation(index, axes.inverse() * turn * axes * rest)


func _ignite() -> void:
	flame.hide()
	lit_tip.show()
	tip_smoke.emitting = true


func _draw_ember() -> void:
	lit_tip.scale = Vector3(1.28, 1.28, 1.05)
	tip_smoke.emitting = false


func _exhale() -> void:
	lit_tip.scale = Vector3.ONE
	tip_smoke.emitting = true
	exhale_smoke.restart()
	exhale_smoke.emitting = true


func _hide_right() -> void:
	right_hand.hide()
	if right_borrowed:
		right_arm.visible = right_was_visible
		right_borrowed = false


func _cleanup() -> void:
	_hide_right()
	pack.hide()
	cigarette.hide()
	lighter.hide()
	flame.hide()
	lit_tip.hide()
	lit_tip.scale = Vector3.ONE
	tip_smoke.emitting = false


func _lower() -> void:
	_move(hand, REST, Vector3(0.10, -0.3, -0.15), 0.42)


func _finish() -> void:
	owner.change_mental_health(mental_health_reward)
	mental_health_reward = 0.0
	_cleanup()
	hand.hide()
	body_arm.show()
