extends Node2D

@onready var item_behavior = ConfigFile.new()

func _ready():
	item_behavior.load("res://behavior/items.cfg")
	
	await RenderingServer.frame_post_draw
	Global.get_inventory().changed_item.connect(_on_item_changed)

func _on_item_changed(new_item: String):
	if has_node("CustomItem"): $CustomItem.queue_free()
	if item_behavior.has_section_key(new_item, "custom_scene"):
		$ItemHolding.hide()
		var custom_item = load(item_behavior.get_value(new_item, "custom_scene")).instantiate()
		custom_item.name = "CustomItem"
		add_child(custom_item)
		return
		
	$ItemHolding.visible = not new_item == "air"
	$ItemHolding.texture = load("res://assets/images/items/%s.png" % new_item)
