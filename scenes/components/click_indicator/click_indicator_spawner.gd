extends Node2D

var click_indicator = preload("res://scenes/components/click_indicator/click_indicator.tscn")

func _input(event):
	if event.is_action_pressed("target"):
		var indicator = click_indicator.instantiate()
		(indicator.material as ShaderMaterial).set_shader_parameter("ring_color", Color("#de384b"))
		add_child(indicator)
	if event.is_action_pressed("interact"):
		var indicator = click_indicator.instantiate()
		add_child(indicator)
