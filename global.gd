extends Node

var f3_enabled: bool = false
var player: CharacterBody2D

var time: float = 8.0 # Military Time

var ambience: AudioStream = preload("res://assets/sounds/ocean.wav")

var commands = {}

func add_command(keyword: String, trigger: Callable):
	commands["/" + keyword] = trigger

func get_inventory():
	assert(get_tree().get_node_count_in_group("inventory_manager") == 1)
	return get_tree().get_first_node_in_group("inventory_manager")

func _process(delta):
	time += delta / 30
	if(time >= 24):
		time = 0
