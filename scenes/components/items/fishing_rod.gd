extends Sprite2D

var last_range_state: int = 1

func _process(_delta: float) -> void:
	$Line.clear_points()
	$Line.add_point($LineOrigin.global_position)
	$Line.add_point(%Bobber.global_position)
	$Range.global_position = get_parent().global_position
	
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") == Vector2.ZERO and not %Bobber.visible:
		if %RangeSprite.modulate == Color.TRANSPARENT:
			%DisappearAnim.play_backwards("disappear")
	elif %RangeSprite.modulate == Color.WHITE:
		%DisappearAnim.play("disappear")

func _on_range_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		var bobber_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		%Bobber.show()
		bobber_tween.tween_property(%Bobber, "unwarped_position", get_global_mouse_position(), 0.1)
		await bobber_tween.finished
		%Bobber.show()
		%Bobber.bobbing = true

func _input(event: InputEvent) -> void:
	if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2.ZERO or event.is_action_pressed("target"):
		var bobber_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		%Bobber.bobbing = false
		bobber_tween.tween_property(%Bobber, "position", Vector2.ZERO, 0.1)
		await bobber_tween.finished
		%Bobber.hide()
