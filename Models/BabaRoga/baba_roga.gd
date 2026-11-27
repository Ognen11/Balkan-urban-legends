extends CharacterBody3D

const Player := preload("res://character_body_3d.gd")
const ATTACK_RANGE := 3.0
const ATTACK_DAMAGE := 50
const WINDUP_TIME := 0.1
const IMPACT_TIME := 0.51
const RECOVERY_TIME := 0.96
const ATTACK_PAUSE := 0.8
const RETARGET_INTERVAL := 0.25
const DETECTION_RANGE := 10.0
const FLEE_DURATION := 5.0
enum State { SEARCH, CHASE, FLEE }
var state := State.SEARCH
var flee_time := 0.0
var search_time := 0.0
var roam_stage := 0
var navigation_ready := false
var stuck_time := 0.0
var progress_position := Vector3.ZERO
var flee_goal := Vector3.ZERO
var detection_cooldown := 0.0
var search_goal := Vector3.ZERO
var flee_direction := Vector3.FORWARD
const CROUCH_ANGLE := deg_to_rad(62.0)
const STEP_HEIGHT := 0.45

@export var chase_speed: float = 3.0

@onready var skeleton: Skeleton3D = $Model/BabaRogaRig/Skeleton3D
@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var chase_sound: AudioStreamPlayer3D = $ChaseSound
@onready var head_bone := skeleton.find_bone("Head")
@onready var chest_bone := skeleton.find_bone("Chest")
@onready var head_rest := skeleton.get_bone_global_pose(head_bone).basis.get_rotation_quaternion()
@onready var chest_rest := skeleton.get_bone_global_pose(chest_bone).basis.get_rotation_quaternion()
@onready var shoulder_bones := [skeleton.find_bone("UpperArm_L"), skeleton.find_bone("UpperArm_R")]
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var target: Player
var retarget_time := 0.0
var attack_time := -1.0
var attack_cooldown := 0.0

@onready var staff_arm := skeleton.find_bone("UpperArm_L")
@onready var staff_forearm := skeleton.find_bone("Forearm_L")
@onready var staff_arm_rest := skeleton.get_bone_pose_rotation(staff_arm)
@onready var staff_forearm_rest := skeleton.get_bone_pose_rotation(staff_forearm)


func _physics_process(delta: float) -> void:
	detection_cooldown = maxf(0.0, detection_cooldown - delta)
	var beam := _find_illuminating_beam()
	if beam:
		target = beam.owner as Player
		flee_direction = global_position - target.global_position
		flee_direction.y = 0.0
		flee_direction = flee_direction.normalized()
		if flee_direction.is_zero_approx():
			flee_direction = global_basis.z
		if state != State.FLEE or global_position.distance_to(flee_goal) < 1.0:
			flee_goal = NavigationServer3D.map_get_closest_point(navigation.get_navigation_map(), global_position + flee_direction * 12.0)
		state = State.FLEE
		flee_time = FLEE_DURATION
		_cancel_attack()
		chase_sound.stop()

	if state == State.FLEE:
		flee_time -= delta
		_travel_to(flee_goal, delta)
		_rest_upper_body(delta)
		if flee_time <= 0.0:
			_start_search()
			detection_cooldown = 1.0
		return

	if state == State.CHASE and (not is_instance_valid(target) or target.health == 0):
		_start_search()

	if state == State.SEARCH:
		var nearby := _find_nearby_player()
		if nearby and detection_cooldown == 0.0:
			target = nearby
			state = State.CHASE
			retarget_time = 0.0
			chase_sound.play()
		else:
			_search(delta)
			return

	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	if attack_time < 0.0 and attack_cooldown == 0.0 and _can_hit_player():
		attack_time = 0.0
	if attack_time >= 0.0:
		_move_body(Vector3.ZERO, delta)
		_pose_upper_body(delta, 16.0)
		_advance_attack(delta)
		return
	_follow_player(delta)
	_pose_upper_body(delta, 16.0)


func _start_search() -> void:
	state = State.SEARCH
	target = null
	search_time = 0.0
	retarget_time = 0.0
	_cancel_attack()
	chase_sound.stop()


func _find_nearby_player() -> Player:
	for node in get_tree().get_nodes_in_group("player"):
		var player := node as Player
		if player == null or player.health == 0:
			continue
		var feet := player.global_position - Vector3.UP
		if global_position.distance_squared_to(feet) > DETECTION_RANGE * DETECTION_RANGE:
			continue
		var ray := PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, player.global_position, 1, [get_rid(), player.get_rid()])
		if get_world_3d().direct_space_state.intersect_ray(ray).is_empty():
			return player
	return null


func _search(delta: float) -> void:
	var map := navigation.get_navigation_map()
	if NavigationServer3D.map_get_iteration_id(map) == 0 or NavigationServer3D.map_get_regions(map).is_empty():
		_move_body(Vector3.ZERO, delta)
		return
	if not navigation_ready and NavigationServer3D.map_get_closest_point(map, global_position).distance_to(global_position) > 1.0:
		_move_body(Vector3.ZERO, delta)
		return
	navigation_ready = true
	stuck_time += delta
	if stuck_time >= 3.0:
		if global_position.distance_to(progress_position) < 0.35:
			search_time = 0.0
		progress_position = global_position
		stuck_time = 0.0
	if search_time == 0.0 or global_position.distance_to(search_goal) < 0.7:
		search_goal = _choose_roaming_goal(map)
		search_time = 1.0
	_travel_to(search_goal, delta)
	_rest_upper_body(delta)


func _choose_roaming_goal(map: RID) -> Vector3:
	# Visit the ground floor and leave the house before roaming the woods.
	if roam_stage == 0:
		if global_position.y > 1.5:
			return NavigationServer3D.map_get_closest_point(map, global_position - Vector3.UP * 4.0)
		roam_stage = 1
	if roam_stage == 1:
		for door in get_tree().get_nodes_in_group("interactable_door"):
			var exit_goal := NavigationServer3D.map_get_closest_point(map, door.to_global(Vector3(0.65, 0, 5.0)))
			if global_position.distance_to(exit_goal) > 1.5:
				return exit_goal
			roam_stage = 2
	for attempt in 20:
		var woods := get_tree().get_first_node_in_group("roaming_woods") as NavigationRegion3D
		var candidate := NavigationServer3D.region_get_random_point(woods.get_region_rid(), navigation.navigation_layers, true) if woods else NavigationServer3D.map_get_random_point(map, navigation.navigation_layers, true)
		var distance := global_position.distance_to(candidate)
		if distance < 8.0 or distance > 65.0:
			continue
		var path := NavigationServer3D.map_get_path(map, global_position, candidate, true)
		if path.size() > 1 and path[path.size() - 1].distance_to(candidate) < 0.8:
			return candidate
	return NavigationServer3D.map_get_closest_point(map, global_position)

func _rest_upper_body(delta: float) -> void:
	var blend := 1.0 - exp(-8.0 * delta)
	_rotate_bone(chest_bone, Quaternion(Vector3.RIGHT, CROUCH_ANGLE) * chest_rest, blend)
	_rotate_bone(head_bone, head_rest, blend)

func _beam_is_on(beam: SpotLight3D) -> bool:
	return is_instance_valid(beam) and beam.is_visible_in_tree() and beam.light_energy > 0.0


func _find_illuminating_beam() -> SpotLight3D:
	for node in get_tree().get_nodes_in_group("player_flashlight"):
		var beam := node as SpotLight3D
		if not _beam_is_on(beam):
			continue
		var player := beam.owner as Player
		if player == null or player.health == 0 or not player.is_in_group("player"):
			continue

		var exclusions: Array[RID] = [player.get_rid(), get_rid()]
		for pane in get_tree().get_nodes_in_group("flashlight_transparent"):
			exclusions.append(pane.get_rid())
		var forward := -beam.global_basis.z.normalized()
		var cone_edge := cos(deg_to_rad(beam.spot_angle))
		var head_pose := skeleton.get_bone_global_pose(head_bone)
		var chest_pose := skeleton.get_bone_global_pose(chest_bone)
		var samples := [
			skeleton.to_global(head_pose * Vector3(0, 0.10, 0.14)),
			skeleton.to_global(chest_pose * Vector3(0, 0.08, 0.12)),
			to_global(Vector3(0, 0.82, 0)),
		]
		for bone in shoulder_bones:
			samples.append(skeleton.to_global(skeleton.get_bone_global_pose(bone).origin))
		for sample: Vector3 in samples:
			var offset := sample - beam.global_position
			if offset.length_squared() > beam.spot_range * beam.spot_range:
				continue
			if forward.dot(offset.normalized()) < cone_edge:
				continue

			var ray := PhysicsRayQueryParameters3D.create(beam.global_position, sample)
			ray.exclude = exclusions
			ray.hit_from_inside = true
			if get_world_3d().direct_space_state.intersect_ray(ray).is_empty():
				return beam
	return null


func _pose_upper_body(delta: float, turn_speed: float) -> void:
	var eyes := target.get_node_or_null("Head") as Node3D
	var look_at_position := eyes.global_position if eyes else target.global_position
	var direction := skeleton.to_local(look_at_position) - skeleton.get_bone_global_pose(chest_bone).origin
	if direction.is_zero_approx():
		return

	# The rig faces +Z. Positive pitch bends the chest forward around its base.
	var yaw := clampf(atan2(direction.x, direction.z), -1.45, 1.45)
	var turn := Quaternion(Vector3.UP, yaw)
	var blend := 1.0 - exp(-turn_speed * delta)
	_rotate_bone(chest_bone, turn * Quaternion(Vector3.RIGHT, CROUCH_ANGLE) * chest_rest, blend)

	var head_origin := skeleton.get_bone_global_pose(head_bone).origin
	var head_direction := (skeleton.to_local(look_at_position) - head_origin).normalized()
	var pitch := clampf(0.26 - asin(clampf(head_direction.y, -1.0, 1.0)), 0.12, 0.75)
	_rotate_bone(head_bone, turn * Quaternion(Vector3.RIGHT, pitch) * head_rest, blend)


func _rotate_bone(bone: int, desired: Quaternion, blend: float) -> void:
	var parent := skeleton.get_bone_parent(bone)
	var parent_rotation := skeleton.get_bone_global_pose(parent).basis.orthonormalized().get_rotation_quaternion()
	var current := skeleton.get_bone_pose_rotation(bone)
	skeleton.set_bone_pose_rotation(bone, current.slerp(parent_rotation.inverse() * desired, blend))


func _player_feet() -> Vector3:
	return target.global_position - Vector3.UP


func _can_hit_player() -> bool:
	if global_position.distance_squared_to(_player_feet()) > ATTACK_RANGE * ATTACK_RANGE:
		return false
	var ray := PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, target.global_position)
	ray.exclude = [get_rid(), target.get_rid()]
	return get_world_3d().direct_space_state.intersect_ray(ray).is_empty()


func _advance_attack(delta: float) -> void:
	var previous := attack_time
	attack_time += delta
	if previous < IMPACT_TIME and attack_time >= IMPACT_TIME and _can_hit_player():
		target.take_damage(target.MAX_HEALTH if target.mental_health < 50.0 else ATTACK_DAMAGE)
	if attack_time >= RECOVERY_TIME:
		_cancel_attack()
		attack_cooldown = ATTACK_PAUSE
		return

	var swing := 0.0
	if attack_time < WINDUP_TIME:
		swing = -smoothstep(0.0, WINDUP_TIME, attack_time)
	elif attack_time < IMPACT_TIME:
		swing = lerpf(-1.0, 0.5, smoothstep(WINDUP_TIME, IMPACT_TIME, attack_time))
	else:
		swing = 0.5 * (1.0 - smoothstep(IMPACT_TIME, RECOVERY_TIME, attack_time))
	skeleton.set_bone_pose_rotation(staff_arm, staff_arm_rest * Quaternion(Vector3.RIGHT, deg_to_rad(95.0) * swing))
	skeleton.set_bone_pose_rotation(staff_forearm, staff_forearm_rest * Quaternion(Vector3.RIGHT, deg_to_rad(32.0) * swing))


func _cancel_attack() -> void:
	if attack_time < 0.0:
		return
	attack_time = -1.0
	skeleton.set_bone_pose_rotation(staff_arm, staff_arm_rest)
	skeleton.set_bone_pose_rotation(staff_forearm, staff_forearm_rest)


func _current_chase_speed() -> float:
	var mental_health := target.mental_health if is_instance_valid(target) else 100.0
	if mental_health <= 20.0:
		return chase_speed + 5.0
	if mental_health < 40.0:
		return chase_speed + 3.0
	if mental_health < 60.0:
		return chase_speed + 2.0
	if mental_health < 80.0:
		return chase_speed + 1.0
	return chase_speed


func _follow_player(delta: float) -> void:
	_travel_to(_player_feet(), delta)


func _travel_to(goal: Vector3, delta: float) -> void:
	for door in get_tree().get_nodes_in_group("interactable_door"):
		var center: Vector3 = door.pivot.to_global(Vector3(0.65, 1.0, -0.1))
		if not door.is_open and not door.locked and center.distance_to(global_position + Vector3.UP) < 2.0:
			door.toggle()
	var map := navigation.get_navigation_map()
	if NavigationServer3D.map_get_iteration_id(map) == 0 or NavigationServer3D.map_get_regions(map).is_empty():
		_move_body(Vector3.ZERO, delta)
		return
	retarget_time -= delta
	if retarget_time <= 0.0 and navigation.target_position.distance_to(goal) > 0.4:
		navigation.target_position = goal
		retarget_time = RETARGET_INTERVAL
	var next := navigation.get_next_path_position()
	var movement := next - global_position
	movement.y = 0.0
	if navigation.is_navigation_finished():
		movement = Vector3.ZERO
	else:
		var distance := movement.length()
		movement = movement.normalized() * minf(1.0, distance / maxf(_movement_speed() * delta, 0.001))
	if movement.length_squared() > 0.001:
		rotation.y = lerp_angle(rotation.y, atan2(movement.x, movement.z), minf(1.0, delta * 6.0))
	_move_body(movement, delta)

func _movement_speed() -> float:
	var speed := chase_speed * 0.65 if state == State.SEARCH else _current_chase_speed()
	if state == State.FLEE:
		speed = maxf(speed, 8.0)
	return speed


func _move_body(movement: Vector3, delta: float) -> void:
	var speed := _movement_speed()
	velocity.x = movement.x * speed
	velocity.z = movement.z * speed
	velocity.y = minf(velocity.y, 0.0) - gravity * delta
	var motion := Vector3(velocity.x, 0.0, velocity.z) * delta
	if is_on_floor() and not motion.is_zero_approx():
		_step_up(motion)
	move_and_slide()


func _step_up(motion: Vector3) -> void:
	if not test_move(global_transform, motion):
		return
	var lift := Vector3.UP * STEP_HEIGHT
	if test_move(global_transform, lift):
		return

	var forward := motion.normalized() * 0.20
	var raised := global_transform.translated(lift)
	if test_move(raised, forward):
		return

	var landing := raised.translated(forward)
	var floor_hit := KinematicCollision3D.new()
	if not test_move(landing, -lift, floor_hit):
		return
	if floor_hit.get_normal().dot(Vector3.UP) < cos(floor_max_angle):
		return

	var step := (lift + floor_hit.get_travel()).y
	if step > 0.02:
		global_position += forward + Vector3.UP * (step + safe_margin)
