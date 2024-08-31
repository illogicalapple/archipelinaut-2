extends TextureRect

@onready var parent = get_parent()

@export var watching_index: int = 0

func _process(_delta):
	$Amount.visible = parent.inventory_amounts[watching_index] > 1
	$TextureRect.visible = parent.inventory_amounts[watching_index] > 0
	$TextureRect.texture = load("res://assets/images/items/" + parent.inventory[watching_index] + ".png")
	$Amount.text = str(parent.inventory_amounts[watching_index])


func _on_hotbar_slot_changed(new_slot: int) -> void:
	if watching_index == new_slot: $AnimationPlayer.play(&"selected")
