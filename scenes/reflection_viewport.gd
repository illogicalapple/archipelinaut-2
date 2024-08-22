extends SubViewport

@export var camera_target: Camera2D

func _ready() -> void:
	var camera = camera_target.get_viewport()
	world_2d = camera.world_2d

func _process(_delta: float) -> void:
	$Camera2D.global_position = camera_target.global_position
	size = get_viewport().get_visible_rect().size
