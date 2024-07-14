extends LineEdit

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interpret(tex: String):
	var spl: PackedStringArray = tex.split(" ")
	if(spl[0] == "/quit"):
		get_tree().quit()
	elif(spl[0] == "/reload"):
		for child in get_tree().current_scene.get_node("Chunks").get_children():
			child.queue_free()
	elif(spl[0] == "/spawn"):
		var count = (int(spl[2]) if spl.size() == 3 else 1)
		if(spl[1] == "pig"):
			for c in range(count):
				var pig = load("res://scenes/components/objects/mob.tscn")
				var i = pig.instantiate()
				i.global_position = Global.player.global_position
				get_tree().current_scene.add_child(i)
		if(spl[1] == "tree"):
			for c in range(count):
				var tree = load("res://scenes/components/objects/tree.tscn")
				var i = tree.instantiate()
				i.global_position = Global.player.global_position
				get_tree().current_scene.add_child(i)
	elif(spl[0] == "/load"):
		var access = DirAccess.get_directories_at("mods/")
		var mod_name = spl[1]
		if(access.has(mod_name)):
			ModManager.load_mod("mods/"+mod_name+"/")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_key_pressed(KEY_SLASH) and !open):
		open = true
		text = "/"
		caret_column = 1
		grab_focus()
	
	if(Input.is_key_pressed(KEY_ENTER) and open):
		interpret(text)
		open = false
	
	if(open):
		scale.x = 1.0
	else:
		scale.x = 0.0
