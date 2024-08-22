extends Node2D

@export var hit: AudioStreamPlayer2D

@export var death: AudioStreamPlayer2D

func on_hit(_health: Node2D, _damage: int, _from):
	hit.play()

func on_death(_health: Node2D, _from):
	death.play()
