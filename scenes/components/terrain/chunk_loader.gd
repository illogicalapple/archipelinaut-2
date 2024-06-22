extends Node2D

@export var seed = 69
@export var target: Node2D
@export var tile_size = 512

var chunk_scene = preload("chunk.tscn")

func load_nearby():
	var center = round(global_position / tile_size) * tile_size
	var chunk_positions = [
		center + Vector2(0, 0),
		center + Vector2(tile_size, tile_size),
		center + Vector2(0, tile_size),
		center + Vector2(-tile_size, tile_size),
		center + Vector2(tile_size, 0),
		center + Vector2(-tile_size, 0),
		center + Vector2(0, -tile_size),
		center + Vector2(-tile_size, -tile_size),
		center + Vector2(tile_size, -tile_size)
	]
	
	for chunk_position in chunk_positions:
		if target.get_node_or_null("Chunk" + str(chunk_position.x) + "_" + str(chunk_position.y)):
			continue
		
		var chunk_instance = chunk_scene.instantiate()
		chunk_instance.name = "Chunk" + str(chunk_position.x) + "_" + str(chunk_position.y)
		chunk_instance.seed = seed
		target.add_child(chunk_instance)
		chunk_instance.global_position = chunk_position

func _process(_delta):
	load_nearby()
