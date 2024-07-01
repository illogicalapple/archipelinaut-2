extends SubViewport

@export var camera_target: Camera2D

func _ready() -> void:
	var camera = camera_target.get_viewport()
	world_2d = camera.world_2d


func _process(delta: float) -> void:
	$Camera2D.global_position = camera_target.global_position
	size = DisplayServer.window_get_size()
