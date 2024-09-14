@tool
extends Sprite2D

@export var inventory_parent: HBoxContainer
@onready var old_separation = inventory_parent.get_theme_constant("separation")

#func _process(delta):
	#offset.x -= inventory_parent.get_theme_constant("separation") - old_separation
	#old_separation = inventory_parent.get_theme_constant("separation")
