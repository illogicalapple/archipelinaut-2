extends HBoxContainer

var selected_slot = 0
var inventory: Array = ["log", "air", "air", "air", "air"]
var inventory_amounts: Array[int] = [1, 0, 0, 0, 0]

func _input(event: InputEvent) -> void:
	for slot in range(5):
		if event.is_action_pressed("slot_" + str(slot)):
			selected_slot = slot
