extends HBoxContainer

signal changed_item(item: String)
signal slot_changed(new_slot: int)

var selected_slot = 0
var inventory: Array = ["air", "air", "air", "air", "air"]
var inventory_amounts: Array[int] = [0, 0, 0, 0, 0]
var offhand: String = "air":
	set(new_item):
		offhand = new_item
		if offhand == "air" or offhand_amount == 0:
			if offhand_slot.modulate == Color.TRANSPARENT: return
			offhand_anim.play_backwards("offhand")
		else: 
			if offhand_slot.modulate == Color.WHITE: return
			offhand_anim.play("offhand")
var offhand_amount: int = 0:
	set(new_amount):
		offhand_amount = new_amount
		if offhand == "air" or offhand_amount == 0:
			if offhand_slot.modulate == Color.TRANSPARENT: return
			offhand_anim.play_backwards("offhand")
		else: 
			if offhand_slot.modulate == Color.WHITE: return
			offhand_anim.play("offhand")

var old_holding: String = "air"
var active_tween: Tween

@export var tooltip: RichTextLabel
@export var anim: AnimationPlayer
@export var offhand_anim: AnimationPlayer

@export var selector_sprite: Sprite2D
@export var offhand_slot: TextureRect

@onready var recipes = ConfigFile.new()

func _ready():
	recipes.load("res://behavior/crafting.cfg")

func _process(_delta):
	if inventory[selected_slot] == "air": inventory_amounts[selected_slot] = 0
	if inventory_amounts[selected_slot] <= 0: inventory[selected_slot] = "air"
	if old_holding != inventory[selected_slot]:
		old_holding = inventory[selected_slot]
		changed_item.emit(inventory[selected_slot])

func switch_to_slot(slot: int):
	if selected_slot == slot: return
	%SelectAnim.stop()
	%SelectAnim.play(&"selected" if selected_slot < slot else &"selected_left")
	if active_tween: active_tween.kill()
	var selector_tw = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	selector_tw.tween_property(selector_sprite, "global_position", $ToGlobal.to_global(get_node("Slot" + str(slot + 1)).position) + Vector2(37, 37), 0.1)
	get_node("Slot" + str(slot + 1)).select_anim = &"selected" if selected_slot < slot else &"selected_left"
	active_tween = selector_tw
	if inventory[slot] == "air":
		tooltip.text = ""
		if anim.is_playing(): anim.advance(2.8 - anim.current_animation_position)
	else:
		if anim.is_playing():
			anim.stop()
			anim.play("tooltip")
			anim.advance(0.1)
		else: anim.play("tooltip")
		update_tooltip()
	selected_slot = slot
	update_tooltip()
	slot_changed.emit(slot)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_up"):
		switch_to_slot(int(fposmod(selected_slot - 1, 5)))
		return
	if event.is_action_pressed("inventory_down"):
		switch_to_slot(int(fposmod(selected_slot + 1, 5)))
		return
	if event.is_action_pressed("offhand"):
		var old_offhand = offhand
		var old_offhand_amount = offhand_amount
		offhand = inventory[selected_slot]
		offhand_amount = inventory_amounts[selected_slot]
		replace(selected_slot + 1, old_offhand, old_offhand_amount)
		update_tooltip()
		if anim.is_playing(): anim.advance(2.8 - anim.current_animation_position)
		return
	if event.is_action_pressed("craft"):
		var to_craft = [inventory[selected_slot], offhand]
		for recipe in recipes.get_sections():
			var ingredients = recipes.get_value(recipe, "recipe", false)
			assert(ingredients, "Item " + recipe + " has no ingredients.")
			if len(ingredients) == 1:
				if to_craft.has(ingredients[0]) and to_craft.has("air"):
					clear(ingredients[0], 1)
					pick_up(recipe, 1)
			if len(ingredients) == 2:
				if to_craft.has(ingredients[0]) and to_craft.has(ingredients[1]):
					clear(ingredients[0], 1)
					clear(ingredients[1], 1)
					pick_up(recipe, 1)
		return
	
	for slot in range(5):
		if not event.is_action_pressed("slot_" + str(slot)): continue
		switch_to_slot(slot)
		return

## Pick up an amount of an item. Returns true if there's space
func pick_up(item: StringName, amount: int = 1) -> bool:
	if inventory.has(item):
		inventory_amounts[inventory.find(item)] += amount
		update_tooltip()
		return true
	elif offhand == item:
		offhand_amount += amount
		return true
	elif inventory.has("air"):
		inventory_amounts[inventory.find("air")] += amount
		inventory[inventory.find("air")] = item
		update_tooltip()
		return true
	return false

func update_tooltip():
	var format = "%sx [outline_color=46825A][color=7EE3A0][wave]%s[/wave][/color][/outline_color]"
	if inventory[selected_slot] == "air": return
	tooltip.text = format % [str(inventory_amounts[selected_slot]), inventory[selected_slot].replace("_", " ")]

func clear(item: StringName, amount: int = -1) -> bool:
	var offhand_mode: bool = offhand == item and offhand_amount >= amount
	if offhand_mode:
		offhand_amount -= amount if amount > 0 else offhand_amount
		if offhand_amount == 0: offhand = "air"
		return true

	if not (inventory.has(item)): return false
	if (inventory_amounts[inventory.find(item)] < amount): return false
	
	inventory_amounts[inventory.find(item)] -= amount if amount > 0 else inventory_amounts[inventory.find(item)]
	if inventory_amounts[inventory.find(item)] <= 0:
		inventory[inventory.find(item)] = "air"
	return true

func replace(slot: int, item: StringName, amount: int = 1) -> bool:
	inventory[slot - 1] = item
	inventory_amounts[slot - 1] = amount
	return true
