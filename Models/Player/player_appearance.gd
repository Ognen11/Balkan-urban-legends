extends Node3D

# The first-person camera excludes layer 2 so the face cannot clip into view.
func _ready() -> void:
	for mesh in find_children("Head_*", "MeshInstance3D", true, false):
		mesh.layers = 2

@onready var aiming_camera: Camera3D = $"../Head/Camera3D"
@onready var holding_arm: Node3D = $"../RightArm"

func _process(_delta: float) -> void:
	holding_arm.rotation.x = aiming_camera.rotation.x + aiming_camera.get_parent().rotation.x
