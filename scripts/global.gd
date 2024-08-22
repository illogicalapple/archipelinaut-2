extends Node

var f3_enabled: bool = false
var player: CharacterBody2D

var time: float = 8.0 # Military Time

var ambience: AudioStream = preload("res://assets/sounds/ocean.wav")

var commands = {}

func add_command(keyword: String, trigger: Callable):
	commands["/" + keyword] = trigger

func _process(delta):
	time += delta / 30
	if(time >= 24):
		time = 0
