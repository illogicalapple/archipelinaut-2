extends Area2D

signal on_interact

var hovered: bool = false

func _ready():
	mouse_entered.connect(enter)
	mouse_exited.connect(exit)

func enter():
	hovered = true

func exit():
	hovered = false

func _process(delta):
	if hovered: modulate = Color(1.4, 1, 1)
	else: modulate = Color.WHITE
	if(Input.is_action_just_pressed("target") and hovered):
		on_interact.emit()
