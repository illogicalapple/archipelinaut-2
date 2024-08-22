extends Sprite2D

@export var rng_seed = 69
@export var target: Node2D
@export var plant = preload("res://scenes/components/objects/tree.tscn")
@export var first_load: bool = true

var collision_image: Image

func _ready():
	texture.noise.seed = rng_seed
	texture.noise.offset = Vector3(
		global_position.x,
		global_position.y,
	0)
	%ChunkName.text = "chunk " + str(position.x / 512) + ", " + str(position.y / 512)
	generate(%ColSprite, global_position)

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
				plant_instance.father_chunk = self
				Save.save_file.set_value(name, "plants", Save.save_file.get_value(name, "plants", []) + [{
					"global_position": plant_instance.global_position
				}])
				target.add_child(plant_instance)
				plants_added += 1
				if plants_added == plants_to_add: return
			await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw

func load_plants(plant_scene: PackedScene):
	for plant in Save.save_file.get_value(name, "plants", []):
		var instance = plant_scene.instantiate()
		for property in plant:
			instance[property] = plant[property]
		instance.father_chunk = self
		target.add_child(instance)

func image_to_polygons(image: Image, threshold: float = 0.1):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image, threshold)
	return bitmap.opaque_to_polygons(Rect2i(0, 0, 512, 512), 9.0)

	
func generate(col_sprite, pos):
	col_sprite.texture.noise.seed = rng_seed
	col_sprite.texture.noise.offset = Vector3(
		pos.x,
		pos.y,
	0)
	await RenderingServer.frame_post_draw
	collision_image = $ColSprite.texture.get_image()
	if first_load:
		call_deferred("spawn_plants", collision_image, plant, randi_range(0, 2))
	else:
		load_plants(plant)
	
	for polygon in image_to_polygons(collision_image):
		var region = NavigationRegion2D.new()
		var navigation_polygon = NavigationPolygon.new()
		navigation_polygon.add_outline(polygon)
		NavigationServer2D.bake_from_source_geometry_data(navigation_polygon, NavigationMeshSourceGeometryData2D.new())
		region.navigation_polygon = navigation_polygon
		add_child(region)
		region.position = Vector2(-256, -256)
		await RenderingServer.frame_post_draw


func _on_player_detect_area_entered(_area: Area2D) -> void:
	if Global.f3_enabled:
		$Border.show()

func _on_player_detect_area_exited(_area: Area2D) -> void:
	$Border.hide()

func _input(event):
	if event.is_action_pressed("debug"):
		$Border.visible = Global.f3_enabled
		if ($PlayerDetect as Area2D).get_overlapping_areas().size() < 1:
			$Border.hide()
