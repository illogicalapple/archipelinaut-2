extends Area2D

signal on_interact

var hovered: bool = false

func _ready():
	mouse_entered.connect(enter)
	mouse_exited.connect(exit)

func enter():
	print("Hovered")
	hovered = true

func exit():
	print("Not Hovered")
	hovered = false

func _process(delta):
	if(Input.is_action_just_pressed("target") and hovered):
		print("Interacted")
		on_interact.emit()
