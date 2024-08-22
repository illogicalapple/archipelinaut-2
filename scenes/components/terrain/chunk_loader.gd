extends Node2D

@export var target: Node2D
@export var plant_target: Node2D
@export var tile_size = 512
@export var chunk_scene = preload("chunk.tscn")
@export_category("Chunk Data")
@export var rng_seed = 69

func load_nearby():
	var center = round(global_position / tile_size) * tile_size
	var chunk_positions = [
		center + Vector2(0, 0),
		center + Vector2(tile_size, tile_size),
		center + Vector2(2 * tile_size, tile_size),
		center + Vector2(0, tile_size),
		center + Vector2(-tile_size, tile_size),
		center + Vector2(-2 * tile_size, tile_size),
		center + Vector2(tile_size, 0),
		center + Vector2(2 * tile_size, 0),
		center + Vector2(-tile_size, 0),
		center + Vector2(-2 * tile_size, 0),
		center + Vector2(0, -tile_size),
		center + Vector2(-tile_size, -tile_size),
		center + Vector2(-2 * tile_size, -tile_size),
		center + Vector2(tile_size, -tile_size),
		center + Vector2(2 * tile_size, -tile_size)
	]
	
	for chunk_position in chunk_positions:
		if target.get_node_or_null("Chunk" + str(chunk_position.x) + "_" + str(chunk_position.y)):
			continue
		
		var chunk_instance = chunk_scene.instantiate()
		chunk_instance.name = "Chunk" + str(chunk_position.x) + "_" + str(chunk_position.y)
		chunk_instance.rng_seed = rng_seed
		chunk_instance.target = plant_target
		chunk_instance.global_position = chunk_position
		target.add_child(chunk_instance)
		chunk_instance.material.set_shader_parameter("reflection_texture", $"../../ReflectionViewport".get_texture())
		
func _process(_delta):
	load_nearby()
