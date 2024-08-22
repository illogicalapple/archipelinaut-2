extends Area2D

var father_chunk: Node2D

func _process(_delta):
	$ParticleEffect.global_position = global_position

func _on_health_manager_on_hit(_health_manager: Node2D, _damage: int, _from: Variant) -> void:
	$ParticleEffect.restart()

func _ready():
	father_chunk.tree_exiting.connect(queue_free)
