extends Node2D

@export var item: PackedScene

func _drop(health, from):
	var drop_instance = item.instantiate()
	drop_instance.global_position = get_parent().global_position
	get_parent().add_sibling(drop_instance)
