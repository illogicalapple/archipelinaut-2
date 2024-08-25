extends Sprite2D

var delta_time: float = 0
var unwarped_position: Vector2 = Vector2.ZERO
var bobbing: bool = false

func _process(delta: float) -> void:
	delta_time += delta
	if bobbing:
		global_position = unwarped_position
		region_rect.size.y = 20 + sin(delta_time) * 5
