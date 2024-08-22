extends Node

var save_file: ConfigFile = ConfigFile.new()

func initialize():
	save_file.set_value("Generation", "seed", 69)
	save_file.set_value("Generation", "chunks_loaded", [])
	save_file.set_value("Objects", "trees", [])
