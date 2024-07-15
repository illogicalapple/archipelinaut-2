extends RichTextLabel

var chunks_loaded = 0
var object_count = 0

var avalible_mods: PackedStringArray

func _input(event):
	if event.is_action_pressed("debug"):
		Global.f3_enabled = not Global.f3_enabled
		visible = Global.f3_enabled
		avalible_mods = DirAccess.get_directories_at("mods/")

func add_line(line: String):
	text += line + "\n"

func update_menu(delta):
	text = "[bgcolor=#0007]"
	add_line("     archipelinaut 2")
	add_line("fps: " + str(Engine.get_frames_per_second()))
	add_line("delta: " + str(delta))
	add_line("loaded chunks: " + str(chunks_loaded))
	add_line("objects: " + str(object_count))
	add_line("time: " + str(Global.time))
	
	add_line("     available mods")
	for i in avalible_mods:
		add_line(i)
	add_line("     active mods")
	for i in ModManager.loaded_mods:
		add_line(i["name"])

func _process(delta):
	update_menu(delta)
