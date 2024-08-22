extends LineEdit

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.add_command("quit",quit)
	Global.add_command("reload",reload)
	Global.add_command("spawn",spawn)
	Global.add_command("load_mod",load_mod)

func quit(_args: PackedStringArray):
	get_tree().quit()

func reload(_args: PackedStringArray):
	for child in get_tree().current_scene.get_node("Chunks").get_children():
		child.queue_free()

func spawn(args: PackedStringArray):
	var count = (int(args[1]) if args.size() == 2 else 1)
	if(args[0] == "pig"):
		for c in range(count):
			var pig = load("res://scenes/components/objects/mob.tscn")
			var i = pig.instantiate()
			i.global_position = Global.player.global_position
			get_tree().current_scene.add_child(i)
	if(args[0] == "tree"):
		for c in range(count):
			var tree = load("res://scenes/components/objects/tree.tscn")
			var i = tree.instantiate()
			i.global_position = Global.player.global_position
			get_tree().current_scene.add_child(i)

func load_mod(args: PackedStringArray):
	var access = DirAccess.get_directories_at("mods/")
	var mod_name = args[0]
	if(access.has(mod_name)):
		ModManager.load_mod("mods/"+mod_name+"/")

func interpret(tex: String):
	var spl: PackedStringArray = tex.split(" ")
	
	if Global.commands.has(spl[0]):
		Global.commands[spl[0]].call(spl.slice(1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
