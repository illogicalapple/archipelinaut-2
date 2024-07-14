extends Node

func _ready():
	print("Mod successfully loaded!")

func _process(delta):
	Global.time += delta * 10
