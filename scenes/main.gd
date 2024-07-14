extends Node2D

func _process(_delta):
	%F3Menu.chunks_loaded = $Chunks.get_child_count()
	%F3Menu.object_count = get_tree().get_nodes_in_group("objects").size()

