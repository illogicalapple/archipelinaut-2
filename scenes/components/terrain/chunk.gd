extends Sprite2D

@export var seed = 69
@export var target: Node2D
@export var plant = preload("res://scenes/components/objects/tree/tree.tscn")
@export var pebbles = preload("res://scenes/components/objects/pebbles/pebbles.tscn")
var collision_image: Image

func _ready():
	texture.noise.seed = seed

func spawn_plants(image: Image, plant_scene: PackedScene, plants_to_add: int):
	if plants_to_add == 0: return
	var spawnable_areas = image_to_polygons(image, 0.9)
	if spawnable_areas.is_empty(): return
	
	var plants_added: int = 0
	for i in range(50):
		var candidate = Vector2(randf_range(0, 512), randf_range(0, 512))
		for polygon in spawnable_areas:
			if Geometry2D.is_point_in_polygon(candidate, polygon):
				var plant_instance = plant_scene.instantiate()
				plant_instance.global_position = global_position + candidate - Vector2(256, 256)
				target.add_child(plant_instance)
				plants_added += 1
				if plants_added == plants_to_add: return

func image_to_polygons(image: Image, threshold: float = 0.1):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image, threshold)
	return bitmap.opaque_to_polygons(Rect2i(0, 0, 512, 512))


func _on_collision_generation_ready() -> void:
	%ColSprite.texture.noise.seed = seed
	%ColSprite.texture.noise.offset = Vector3(
		global_position.x,
		global_position.y,
	0)
	await RenderingServer.frame_post_draw
	collision_image = $CollisionGeneration.get_texture().get_image()
	spawn_plants(collision_image, plant, randi_range(0, 2))
	
	for polygon in image_to_polygons(collision_image):
		var region = NavigationRegion2D.new()
		var navigation_polygon = NavigationPolygon.new()
		navigation_polygon.add_outline(polygon)
		navigation_polygon.make_polygons_from_outlines()
		region.navigation_polygon = navigation_polygon
		add_child(region)
		region.position = Vector2(-256, -256)
