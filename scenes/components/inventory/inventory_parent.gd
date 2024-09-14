@tool
extends HBoxContainer

func _process(delta):
	size.x = 0
	set_anchors_preset(Control.PRESET_CENTER_BOTTOM, true)
	offset_left = 0
	offset_right = 0
	if not Engine.is_editor_hint():
		add_theme_constant_override("separation", get_theme_constant("separation") + delta * 30)
