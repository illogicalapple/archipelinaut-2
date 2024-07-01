extends SubViewport


func _ready() -> void:
	var camera = $"../Player/Camera2D".get_viewport()
	
	world_2d = camera.world_2d


func _process(delta: float) -> void:
	$Camera2D.global_position = $"../Player/Camera2D".global_position
	size = DisplayServer.window_get_size()
