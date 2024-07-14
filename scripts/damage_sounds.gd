extends Node2D

@export var hit: AudioStreamPlayer2D

@export var death: AudioStreamPlayer2D

func on_hit(health: Node2D, damage: int, from):
	hit.play()

func on_death(health: Node2D, from):
	death.play()
