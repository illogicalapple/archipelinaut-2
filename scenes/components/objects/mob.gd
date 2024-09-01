extends CharacterBody2D

@export var can_panic = true

var movement_speed: float = 100.0
var tweening = false
var tweening_to = 1
var panic_mode = false

var active = true
var scale_tw: Tween

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func start_panicking():
	panic_mode = true
	_on_navigation_agent_2d_navigation_finished()
	await get_tree().create_timer(randf_range(3, 5)).timeout
	panic_mode = false

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func recoil(dir: Vector2, force: float, falloff: float):
	var vel = dir * force
	while vel.length() > 0.01:
		var c = get_slide_collision_count()
		
		if(c > 0):
			velocity = velocity.bounce(get_slide_collision(0).get_normal())
		velocity = vel / get_process_delta_time()
		move_and_slide()
		
		vel -= vel * falloff * get_process_delta_time()
		await get_tree().process_frame

func _physics_process(_delta):
	if panic_mode: movement_speed = 400
	else: movement_speed = 100
	if(active):
		if navigation_agent.is_navigation_finished():
			$AnimationPlayer.speed_scale = 0
			$Texture.rotation = 0
			return
	
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		$AnimationPlayer.speed_scale = velocity.distance_to(Vector2.ZERO) / 50
		
		if (not tweening) or tweening_to != sign(velocity.x):
			if scale_tw: scale_tw.stop()
			scale_tw = get_tree().create_tween()
			scale_tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			tweening = true
			tweening_to = sign(velocity.x)
			if velocity.x < 0:
				scale_tw.tween_property($Texture, "scale", Vector2(-1, 1), 0.3)
			else:
				scale_tw.tween_property($Texture, "scale", Vector2(1, 1), 0.3)
			scale_tw.finished.connect(set_deferred.bind("tweening", false))
		
		move_and_slide()


func on_hit(_health: Node2D, _damage: int, from):
	start_panicking()
	recoil(from.global_position.direction_to(global_position),10,9)

func _on_timer_timeout() -> void:
	set_movement_target(global_position + Vector2(randf_range(-500, 500), randf_range(-500, 500)))


func _on_navigation_agent_2d_navigation_finished() -> void:
	$Timer.wait_time = randf_range(1, 4)
	if panic_mode:
		$Timer.wait_time = randf_range(0.1, 0.2)
	$Timer.start()

func _die(_health, _from):
	active = false
	queue_free()

func _on_misc_sound_timer_timeout() -> void:
	$OinkSound.play()
	$MiscSoundTimer.wait_time = randf_range(1, 3)
	$MiscSoundTimer.start()


func _on_collision_shape_2d_interact() -> void:
	Global.player.damage_dealer.damage(self, 1)
