extends TextureRect

@onready var parent = get_parent()

@export var watching_index: int = 0

func _process(_delta):
	if parent.inventory_amounts[watching_index] <= 1:
		$Amount.hide()
	if parent.inventory_amounts[watching_index] <= 0:
		$TextureRect.hide()
	if parent.selected_slot == watching_index:
		texture = preload("res://assets/images/ui/slot_selected.png")
	else:
		texture = preload("res://assets/images/ui/slot.png")
	$TextureRect.texture = load("res://assets/images/items/" + parent.inventory[watching_index] + ".png")
