extends Node2D
class_name Reflection2D

@export var reflection_sprite : Sprite2D

var sprite : Sprite2D

func _ready():
	sprite = Sprite2D.new()
	sprite.texture = reflection_sprite.texture
	sprite.z_index = -1

	# Sets visibility layer to 3, since 4 in binary is 100
	sprite.visibility_layer = 4
	add_child(sprite)


func _process(_delta):
	sprite.position = global_position - reflection_sprite.global_position
	sprite.scale = reflection_sprite.scale * Vector2(1, -1)
	sprite.rotation = -reflection_sprite.rotation
