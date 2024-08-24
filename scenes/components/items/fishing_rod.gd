extends Sprite2D

func _process(_delta: float) -> void:
	$Line.clear_points()
	$Line.add_point($LineOrigin.position)
	$Line.add_point($Bobber.position)
	$Range.global_position = get_parent().global_position


func _on_range_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	pass # Replace with function body.
