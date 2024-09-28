extends TextureRect

@export var parent: Node
@export var watching_index: int = 0
@export var select_anim := &"selected"
@export var offhand: bool = false

var old_amount = 0
var old_item = "air"

func _process(_delta):
	var amount = parent.offhand_amount if offhand else parent.inventory_amounts[watching_index]
	var item = parent.offhand if offhand else parent.inventory[watching_index]
	$Amount.visible = amount > 1
	$TextureRect.visible = amount > 0
	
	$TextureRect.texture = load("res://assets/images/items/" + item + ".png")
	$Amount.text = str(amount)
	if old_item != item:
		if old_item == "air":
			$OldTexture.hide()
		else:
			$OldTexture.show()
			$OldTexture.texture = load("res://assets/images/items/" + old_item + ".png")
		$AmountAnim.play("new_item")
		old_item = item
		old_amount = amount
	elif amount != old_amount:
		$AmountAnim.play("amount_changed")
		old_amount = amount

func _on_hotbar_slot_changed(new_slot: int) -> void:
	if watching_index == new_slot: $AnimationPlayer.play(select_anim)
