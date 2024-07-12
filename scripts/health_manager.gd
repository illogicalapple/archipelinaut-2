extends Node2D

@export_group("Stats")

@export var max_health: int
@export var health: int

@export_group("Events")

@export var call_hit_on_death: bool = true

## Passes a health_manager: Node2D, damage: int, and from: Node
signal on_hit(health_manager: Node2D, damage: int, from)
## Passes a health_manager: Node2D, from: Node
signal on_death(health_manager: Node2D, from)

func deal(damage: int, from):
	if(health <= 0):
		return
	health -= damage
	if(health <= 0):
		on_death.emit(self, from)
		if(call_hit_on_death):
			on_hit.emit(self,damage,from)
	else:
		on_hit.emit(self,damage,from)

func _on_interact():
	deal(1,Global.player)
