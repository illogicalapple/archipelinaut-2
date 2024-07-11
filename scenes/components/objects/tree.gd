extends Area2D

@export_group("Setup")

@export var leaf_count: int = 4
@export var trunk_detail: int = 16
@export var leaf_detail: int = 16
@export var simualation_distance: float = 720
@export var shadow_scale: float = 32

@export_group("Looks")

@export_group("Looks/Trunk")

@export var trunk_width: float = 24
@export var trunk_width_curve: Curve = null
@export var trunk_color: Color = Color8(152,103,77,255)
@export var trunk_gradient: Gradient = null

@export_group("Looks/Leaves")

@export var leaf_width: float = 24
@export var leaf_width_curve: Curve = null
@export var leaf_color: Color = Color8(64,160,96,255)
@export var leaf_gradient: Gradient = null

@export_group("Generation")

@export_group("Generation/Trunk")
@export var trunk_length: float = 80 # This is the total length of the trunk
@export_range(0.0,1.0) var trunk_length_randomization: float = 0.5

@export_group("Generation/Leaves")
@export var leaf_length: float = 80
@export_range(0.0,1.0) var leaf_length_randomization: float = 0.5
@export var leaf_angle_falloff: float = 2.0
@export var leaf_droop: float = 1.0

@export_group("Wind")

@export_group("Wind/Leaves")
@export var leaf_wind_strength: Vector2 = Vector2(8.0,16.0)
@export var leaf_wind_speed: Vector2 = Vector2(1.0,3.0)
@export_range(-1.0,1.0) var leaf_horizontal_wind_direction_tendancy: float = -1

@export_group("Wind/Trunk")
@export var trunk_wind_strength: Vector2 = Vector2(8.0,4.0)
@export var trunk_wind_speed: Vector2 = Vector2(1.0,3.0)
@export_range(-1.0,1.0) var trunk_horizontal_wind_direction_tendancy: float = -0.8

var _leaves: Array[Line2D]
var _leaf_points: Array
var _trunk: Line2D
var _trunk_points: Array[Vector2]
var _time = 0
var _shadow: Sprite2D = null

func _ready():
	_shadow = Sprite2D.new()
	_shadow.texture = preload("res://assets/images/shadow.png")
	var s = shadow_scale/180.0
	_shadow.scale = Vector2(s,s * 0.5)
	add_child(_shadow)
	_shadow.global_position = global_position
	
	_time += randf_range(-100,100)
	
	_trunk = Line2D.new()
	_trunk.width = trunk_width
	_trunk.width_curve = trunk_width_curve
	_trunk.default_color = trunk_color
	_trunk.gradient = trunk_gradient
	_trunk.joint_mode = Line2D.LINE_JOINT_ROUND
	_trunk.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_trunk.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(_trunk)
	_trunk.global_position = global_position
	var branch_joint = generate_trunk(_trunk, 0, trunk_length + trunk_length * randf_range(-trunk_length_randomization,trunk_length_randomization), 16)
	_trunk_points.append_array(_trunk.points.duplicate())
	
	for i in range(leaf_count):
		
		# create leaf node
		var l: Line2D = Line2D.new()
		l.width = leaf_width
		l.width_curve = leaf_width_curve
		l.default_color = leaf_color
		l.gradient = leaf_gradient
		l.joint_mode = Line2D.LINE_JOINT_ROUND
		l.begin_cap_mode = Line2D.LINE_CAP_ROUND
		l.end_cap_mode = Line2D.LINE_CAP_ROUND
		l.z_index = 1
		add_child(l)
		l.global_position = global_position
		
		var rot = 2.4 / (float(int(i/2) + 1) * 1/leaf_angle_falloff)
		
		var dir = 1
		
		if(i%2 == 0):
			dir = -1
			rot *= -1
		
		generate_leaf(l, rot, dir, leaf_length  + leaf_length * randf_range(-leaf_length_randomization,leaf_length_randomization), leaf_detail)
		_leaf_points.append(l.points.duplicate())
		_leaves.append(l)

func generate_trunk(target: Line2D ,starting_rotation: float = 0, length: float = 80, detail: int = 50) -> Vector2:
	length /= detail
	target.add_point(Vector2.ZERO)
	
	var current_point = Vector2.ZERO
	var trunk_rotation = starting_rotation
	var rotation_velocity = sign(starting_rotation + randf_range(-0.1, 0.1)) * randf_range(1.0, 1.5)
	for section in range(detail):
		trunk_rotation += rotation_velocity / 1000  * length
		current_point += Vector2.UP.rotated(trunk_rotation) * length
		target.add_point(current_point)
	
	return current_point

func generate_leaf(target: Line2D, starting_rotation: float = 0, rotation_direction: int = 0, length: float = 80, detail: int = 50) -> Vector2:
	length /= detail
	target.add_point(Vector2.ZERO)
	
	var current_point = Vector2.ZERO
	var trunk_rotation = starting_rotation
	var rotation_velocity = sign(rotation_direction * 100 + starting_rotation + randf_range(-0.1, 0.1)) * randf_range(1.0, 1.5)
	for section in range(detail):
		trunk_rotation += rotation_velocity / 50  * length * leaf_droop
		current_point += Vector2.UP.rotated(trunk_rotation) * length
		target.add_point(current_point)
	
	return current_point

func draw_leaf(points: Array[Vector2], connection_point: Vector2, out: Line2D):
	if(out.points.size() != points.size()):
		out.points.resize(points.size())
	for p in range(points.size()):
		var y = sin(p * 0.1 + _time * leaf_wind_speed.y) * leaf_wind_strength.y * (float(p)/points.size())
		var x = (sin(p * 0.02 + _time * leaf_wind_speed.x)+leaf_horizontal_wind_direction_tendancy) * leaf_wind_strength.x * (float(p)/points.size())
		out.points[p] = points[p] + Vector2(x,y) + connection_point

func draw_trunk(points: Array[Vector2], out: Line2D):
	if(out.points.size() != points.size()):
		out.points.resize(points.size())
	for p in range(points.size()):
		var y = sin(p * 0.1 + _time * trunk_wind_speed.y) * trunk_wind_strength.y * (float(p)/points.size())
		var x = (sin(p * 0.02 + _time * trunk_wind_speed.x)+trunk_horizontal_wind_direction_tendancy) * trunk_wind_strength.x * (float(p)/points.size())
		out.points[p] = points[p] + Vector2(x,y)

func _process(delta):
	if !Global.player or (Global.player.global_position.distance_to(global_position) < simualation_distance):
		draw_trunk(_trunk_points,_trunk)
		for i in range(_leaves.size()):
			draw_leaf(_leaf_points[i],_trunk.points[_trunk.points.size() - 1],_leaves[i])
		_time += delta
