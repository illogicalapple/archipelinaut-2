extends Node2D

func damage(target: Node, amount: float):
	var health_manager = target.get_node_or_null("HealthManager")
	assert(health_manager != null, "Node \"" + target.name + "\" is missing a HealthManager.")
	
	health_manager.deal(amount, get_parent())
