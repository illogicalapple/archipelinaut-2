extends Node

var freeze = -1
var stopped = false

func _ready():
	print("Mod successfully loaded!")
	Global.add_command("stop",stop)
	Global.add_command("start",start)

func stop(args: PackedStringArray):
	print("Stopping")
	stopped = true
	freeze = Global.time

func start(args: PackedStringArray):
	print("Starting")
	stopped = false

func _process(delta):
	Global.time += delta * 10
	if(stopped):
		Global.time = freeze
