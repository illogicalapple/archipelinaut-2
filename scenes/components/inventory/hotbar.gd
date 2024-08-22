extends HBoxContainer

signal changed_item(item: String)

var selected_slot = 0
var inventory: Array = ["air", "air", "air", "air", "air"]
var inventory_amounts: Array[int] = [0, 0, 0, 0, 0]

var old_holding: String = "air"

@onready var tooltip = $"../Tooltip"
@onready var anim = $"../TooltipAnim"

func _process(_delta):
	if inventory[selected_slot] == "air": inventory_amounts[selected_slot] = 0
	if inventory_amounts[selected_slot] <= 0: inventory[selected_slot] = "air"
	if old_holding != inventory[selected_slot]:
		old_holding = inventory[selected_slot]
		changed_item.emit(inventory[selected_slot])

func _input(event: InputEvent) -> void:
	for slot in range(5):
		if event.is_action_pressed("slot_" + str(slot)):
			if selected_slot != slot:
				if inventory[slot] == "air":
					tooltip.text = ""
					if anim.is_playing(): anim.advance(2.8 - anim.current_animation_position)
				else:
					if anim.is_playing():
						anim.stop()
						anim.play("tooltip")
						anim.advance(0.1)
					else: anim.play("tooltip")
					tooltip.text = str(inventory_amounts[slot]) + "x [color=7EE3A0][wave]" + inventory[slot] + "[/wave][/color]"
			selected_slot = slot

## Pick up an amount of an item. Returns true if there's space
func pick_up(item: StringName, amount: int = 1) -> bool:
	if inventory.has(item):
		inventory_amounts[inventory.find(item)] += amount
		tooltip.text = str(inventory_amounts[selected_slot]) + "x [color=7EE3A0][wave]" + inventory[selected_slot] + "[/wave][/color]"
		return true
	elif inventory.has("air"):
		inventory_amounts[inventory.find("air")] += amount
		inventory[inventory.find("air")] = item
		tooltip.text = str(inventory_amounts[selected_slot]) + "x [color=7EE3A0][wave]" + inventory[selected_slot] + "[/wave][/color]"
		return true
	return false
