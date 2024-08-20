extends TextureRect

@onready var parent = get_parent()

@export var watching_index: int = 0

func _process(_delta):
	$TextureRect.texture = load("res://assets/images/items/" + parent.inventory[watching_index] + ".png")
