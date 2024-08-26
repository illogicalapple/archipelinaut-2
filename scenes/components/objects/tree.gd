extends Node2D

@export_group("Behavior")
@export var drop: String = "log"

@export_group("Setup")

@export var leaf_count: int = 4
@export var trunk_detail: int = 16
@export var leaf_detail: int = 16
@export var simualation_distance: float = 720
@export var shadow_scale: float = 32
@export var health_manager: Node2D

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
@export var leaf_stiffness: float = 0.0
@export var leaf_drag: float = 0.0

@export_group("Wind/Trunk")
@export var trunk_wind_strength: Vector2 = Vector2(8.0,4.0)
@export var trunk_wind_speed: Vector2 = Vector2(1.0,3.0)
@export_range(-1.0,1.0) var trunk_horizontal_wind_direction_tendancy: float = -0.8
@export var trunk_stiffness: float = 0.0
@export var trunk_drag: float = 0.0

var _leaves: Array[Line2D]
var _leaf_points: Array
var _leaves_alive: Array[bool]
var _leaves_dead_time: Array[float]
var _trunk: Line2D
var _trunk_points: Array[Vector2]
var _time = 0
var _shadow: Sprite2D = null
var _trunk_jiggle_position = Vector2.ZERO
var _leaf_jiggle_position = Vector2.ZERO
var _trunk_anti_jiggle_velocity = Vector2.ZERO
var _leaf_anti_jiggle_velocity = Vector2.ZERO
var _final_trunk_length = 0
var _dead = false
var _trunk_scale = 1.0
# var _drop = preload("res://scenes/components/objects/item.tscn")

func _ready():
	if(!health_manager):
		if(get_parent()):
			if("health" in get_parent()):
				get_parent().health = leaf_count
				get_parent().max_health = leaf_count
				get_parent().on_hit.connect(_on_hit)
				get_parent().on_death.connect(_on_death)
	else:
		health_manager.health = leaf_count
		health_manager.max_health = leaf_count
		health_manager.on_hit.connect(_on_hit)
		health_manager.on_death.connect(_on_death)
	_shadow = Sprite2D.new()
	_shadow.texture = preload("res://assets/images/shadow.png")
	_shadow.z_index = -1
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
	_trunk.antialiased = true
	add_child(_trunk)
	_trunk.global_position = global_position
	_final_trunk_length = trunk_length + trunk_length * randf_range(-trunk_length_randomization,trunk_length_randomization)
	var _branch_joint = generate_trunk(_trunk, 0, _final_trunk_length, 16)
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
		l.antialiased = true
		add_child(l)
		l.global_position = global_position
		
		var rot = 2.4 / (float(int(i/2.0) + 1) * 1.0/leaf_angle_falloff)
		
		var dir = 1
		
		if(i%2 == 0):
			dir = -1
			rot *= -1
		
		generate_leaf(l, rot, dir, leaf_length  + leaf_length * randf_range(-leaf_length_randomization,leaf_length_randomization), leaf_detail)
		_leaf_points.append(l.points.duplicate())
		_leaves.append(l)
		_leaves_alive.append(true)
		_leaves_dead_time.append(0.0)

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

func draw_leaf(points: Array[Vector2], connection_point: Vector2, out: Line2D, alive: bool, time_dead: float):
	if(out.points.size() != points.size()):
		out.points.resize(points.size())
	time_dead *= time_dead
	for p in range(points.size()):
		var y = sin(p * 0.1 + _time * leaf_wind_speed.y) * leaf_wind_strength.y * (float(p)/points.size())
		var x = (sin(p * 0.02 + _time * leaf_wind_speed.x)+leaf_horizontal_wind_direction_tendancy) * leaf_wind_strength.x * (float(p)/points.size())
		var con = connection_point
		if(!alive):
			var m = 32
			if(time_dead > _final_trunk_length):
				time_dead = _final_trunk_length
			m = 1.0 - (time_dead / _final_trunk_length)
			con = _trunk_points.back() + Vector2(sin(_time) * m + sin(points.back().x) * ((1-m) * 64),time_dead)
			points[p] *= clampf(0.5 + m,0.0,1.0)
		out.points[p] = points[p] + Vector2(x,y) + con + _leaf_jiggle_position * (float(p)/points.size())

func draw_trunk(points: Array[Vector2], out: Line2D):
	if(out.points.size() != points.size()):
		out.points.resize(points.size())
	for p in range(points.size()):
		var y = sin(p * 0.1 + _time * trunk_wind_speed.y) * trunk_wind_strength.y * (float(p)/points.size())
		var x = (sin(p * 0.02 + _time * trunk_wind_speed.x)+trunk_horizontal_wind_direction_tendancy) * trunk_wind_strength.x * (float(p)/points.size())
		out.points[p] = (points[p] * _trunk_scale) + Vector2(x,y) + _trunk_jiggle_position * (float(p)/points.size())

func apply_force(force: Vector2):
	_leaf_anti_jiggle_velocity -= force
	_trunk_anti_jiggle_velocity += force

func _on_hit(_health: Node2D, damage: int, _from):
	apply_force(Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() * 720)
	for z in range(damage):
		var found = false
		for i in range(_leaves_alive.size()):
			if(_leaves_alive[i] == true):
				_leaves_alive[i] = false
				found = true
				break
		if(!found):
			break

func _on_death(_health: Node2D, _from):
	for i in range(_leaves_alive.size()):
		if(_leaves_alive[i] == true):
			_leaves_alive[i] = false
	_dead = true

func _process(delta):
	if !Global.player or (Global.player.global_position.distance_to(global_position) < simualation_distance):
		draw_trunk(_trunk_points,_trunk)
		var all_gone = true
		for i in range(_leaves.size()):
			if(!is_instance_valid(_leaves[i])):
				continue
			all_gone = false
			var p = _trunk.points[_trunk.points.size() - 1]
			draw_leaf(_leaf_points[i],p,_leaves[i],_leaves_alive[i], _leaves_dead_time[i])
			if(!_leaves_alive[i]):
				_leaves_dead_time[i] += delta * 16
				_leaves[i].z_index = -1
				_leaves[i].self_modulate.a = lerpf(_leaves[i].self_modulate.a,0.0,0.5*delta)
				if(_leaves[i].self_modulate.a < 0.01):
					_leaves[i].queue_free()
		if(all_gone):
			queue_free()
		_time += delta
		if(_dead):
			_trunk_scale = lerpf(_trunk_scale,0.0,10*delta)
			_trunk.self_modulate.a = lerpf(_trunk.self_modulate.a,0.0,5*delta)
			_shadow.self_modulate.a = lerpf(_shadow.self_modulate.a,0.0,7*delta)
			

func _physics_process(delta):
	_leaf_anti_jiggle_velocity += _leaf_jiggle_position * delta * leaf_stiffness
	_trunk_anti_jiggle_velocity += _trunk_jiggle_position * delta * trunk_stiffness
	
	_leaf_anti_jiggle_velocity -= _leaf_anti_jiggle_velocity * delta * leaf_drag
	_trunk_anti_jiggle_velocity -= _trunk_anti_jiggle_velocity * delta * trunk_drag
	
	_leaf_jiggle_position -= _leaf_anti_jiggle_velocity * delta
	_trunk_jiggle_position -= _trunk_anti_jiggle_velocity * delta
