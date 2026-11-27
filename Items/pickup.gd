extends Area3D

@export var item_id: StringName = &"cigarette_box"
@export var display_name := "Cigarettes"
var collected := false


func collect(player: CharacterBody3D) -> bool:
	if collected or not player.add_inventory_item(item_id, display_name, self):
		return false
	collected = true
	collision_layer = 0
	hide()
	return true


func respawn() -> void:
	collected = false
	collision_layer = 128
	show()