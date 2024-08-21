extends Node2D

var item: PackedScene = preload("res://scenes/components/objects/item.tscn")
@export var item_name: String

func _drop(health, from):
	var drop_instance = item.instantiate()
	drop_instance.item = item_name
	drop_instance.global_position = get_parent().global_position
	get_parent().add_sibling(drop_instance)
