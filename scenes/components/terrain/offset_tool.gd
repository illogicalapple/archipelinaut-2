@tool
extends Node2D

func _process(_delta):
	get_parent().texture.noise.offset = Vector3(
		get_parent().global_position.x,
		get_parent().global_position.y,
	0)
