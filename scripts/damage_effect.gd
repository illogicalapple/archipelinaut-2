extends Node2D

@export var hit: PackedScene

@export var death: PackedScene

func on_hit(health: Node2D, damage: int, from):
	var h = hit.instantiate()
	h.global_position = global_position
	h.look_at(h.global_position + from.global_position.direction_to(global_position))
	if "emitting" in h:
		h.emitting = true
	get_tree().current_scene.add_child(h)

func on_death(health: Node2D, from):
	var d = death.instantiate()
	d.global_position = global_position
	d.look_at(d.global_position + from.global_position.direction_to(global_position))
	if "emitting" in d:
		d.emitting = true
	get_tree().current_scene.add_child(d)
