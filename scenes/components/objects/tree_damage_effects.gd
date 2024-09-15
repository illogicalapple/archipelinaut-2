extends Area2D

@export var save_index: int = 0

var father_chunk
var section_name: StringName

func _process(_delta):
	$ParticleEffect.global_position = global_position

func _on_health_manager_on_hit(_health_manager: Node2D, _damages: int, _from: Variant) -> void:
	$ParticleEffect.restart()

func _ready():
	await RenderingServer.frame_post_draw
	section_name = father_chunk.name
	father_chunk.tree_exiting.connect(queue_free)

func _on_health_manager_on_death(_health_manager: Node2D, _from: Variant) -> void:
	var plants: Array = Save.save_file.get_value(section_name, "plants")
	(plants as Array).remove_at(save_index)


func _on_collision_interact() -> void:
	Global.player.damage_dealer.damage(self, 1)
