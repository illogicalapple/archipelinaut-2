extends Node

var loaded_mods = []

func load_mod(path: String):
	if(FileAccess.file_exists(path + "main.gd")):
		var mod = {}
		var main = load(path + "main.gd")
		mod["main"] = main
		mod["node"] = Node.new()
		mod["node"].set_script(main)
		var n = path.split("/")
		mod["name"] = n[n.size()-2]
		add_child(mod["node"])
		loaded_mods.append(mod)
	else:
		print("Failed to load mod! No main.gd file found!")
