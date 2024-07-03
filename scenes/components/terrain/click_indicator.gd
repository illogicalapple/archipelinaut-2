extends Sprite2D


func play():
	var tween = get_tree().create_tween()
	tween.tween_method(func(t): material.set_shader_parameter("t", t), 0., 1., 1.)
	

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		global_position = get_global_mouse_position()
		play()
