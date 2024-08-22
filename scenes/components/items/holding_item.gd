extends Node2D

func _ready():
	await RenderingServer.frame_post_draw
	Global.get_inventory().changed_item.connect(_on_item_changed)

func _on_item_changed(new_item: String):
	$ItemHolding.visible = not new_item == "air"
	$ItemHolding.texture = load("res://assets/images/items/%s.png" % new_item)
