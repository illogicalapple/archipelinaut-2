extends Area2D

func _process(delta):
	$ParticleEffect.global_position = global_position

func _on_health_manager_on_hit(health_manager: Node2D, damage: int, from: Variant) -> void:
	$ParticleEffect.restart()
