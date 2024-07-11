extends RichTextLabel

var chunks_loaded = 0
var object_count = 0

func _input(event):
	if event.is_action_pressed("debug"):
		Global.f3_enabled = not Global.f3_enabled
		visible = Global.f3_enabled

func add_line(line: String):
	text += line + "\n"

func update_menu(delta):
	text = "[bgcolor=#0007]"
	add_line("archipelinaut 2")
	add_line("fps: " + str(Engine.get_frames_per_second()))
	add_line("delta: " + str(delta))
	add_line("loaded chunks: " + str(chunks_loaded))
	add_line("objects: " + str(object_count))
	add_line("time (military time): " + str(Global.time))

func _process(delta):
	update_menu(delta)
