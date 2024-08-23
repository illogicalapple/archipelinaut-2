extends Area2D

@export var save_index: int = 0

var father_chunk: Node2D
@onready var section_name: StringName = father_chunk.name

func _process(_delta):
	$ParticleEffect.global_position = global_position

func _on_health_manager_on_hit(_health_manager: Node2D, _damage: int, _from: Variant) -> void:
	$ParticleEffect.restart()

func _ready():
	father_chunk.tree_exiting.connect(queue_free)


func _on_health_manager_on_death(health_manager: Node2D, from: Variant) -> void:
	var plants: Array = Save.save_file.get_value(section_name, "plants")
	(plants as Array).remove_at(save_index)
