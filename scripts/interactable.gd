class_name Interactable2D
extends CollisionShape2D

signal interact

@export var interact_action: StringName = &"target"
var hovered: bool = false

func _ready():
	get_parent().input_pickable = true
	get_parent().mouse_entered.connect(enter)
	get_parent().mouse_exited.connect(exit)

func enter():
	hovered = true

func exit():
	hovered = false

func _process(_delta):
	
	if(hovered):
		get_parent().modulate = Color(1.4, 1, 1)
		get_parent().set_visibility_layer_bit(3,true)
	else:
		get_parent().modulate = Color.WHITE
		get_parent().set_visibility_layer_bit(3,false)
	
	if(Input.is_action_just_pressed(interact_action) and hovered):
		interact.emit()
