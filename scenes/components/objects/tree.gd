extends Area2D

func _ready():
	var branch_joint = generate_trunk(0, 75)
	generate_leaf($Leaf1, branch_joint, -1.2, -1, 75)
	generate_leaf($Leaf2, branch_joint, 1.2, 1, 75)
	generate_leaf($Leaf3, branch_joint, 0.5, 1, 75)
	generate_leaf($Leaf4, branch_joint, -0.6, -1, 75)

func generate_trunk(starting_rotation: float = 0, length: int = 50) -> Vector2:
	$Trunk.add_point(Vector2.ZERO)
	
	var current_point = Vector2.ZERO
	var trunk_rotation = starting_rotation
	var rotation_velocity = sign(starting_rotation + randf_range(-0.1, 0.1)) * randf_range(1.0, 1.5)
	for section in range(length):
		trunk_rotation += rotation_velocity / 1000
		current_point += Vector2.UP.rotated(trunk_rotation)
		$Trunk.add_point(current_point)
	
	return current_point

func generate_leaf(target: Line2D, from: Vector2, starting_rotation: float = 0, rotation_direction: int = 0, length: int = 50) -> Vector2:
	target.add_point(from)
	
	var current_point = from
	var trunk_rotation = starting_rotation
	var rotation_velocity = sign(rotation_direction * 100 + starting_rotation + randf_range(-0.1, 0.1)) * randf_range(1.0, 1.5)
	for section in range(length):
		trunk_rotation += rotation_velocity / 50
		current_point += Vector2.UP.rotated(trunk_rotation)
		target.add_point(current_point)
	
	return current_point
