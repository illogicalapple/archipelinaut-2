extends CharacterBody2D

var movement_speed: float = 100.0
var tweening = false
var tweening_to = 1

var active = true

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var scale_tw = get_tree().create_tween()

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if(active):
		if navigation_agent.is_navigation_finished():
			$AnimationPlayer.speed_scale = 0
			$Sprite2D.rotation = 0
			return
	
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		$AnimationPlayer.speed_scale = velocity.distance_to(Vector2.ZERO) / 50
		
		if (not tweening) or tweening_to != sign(velocity.x):
			var scale_tw = get_tree().create_tween()
			scale_tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			tweening = true
			tweening_to = sign(velocity.x)
			if velocity.x < 0:
				scale_tw.tween_property($Sprite2D, "scale", Vector2(-1, 1), 0.3)
			else:
				scale_tw.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.3)
			scale_tw.finished.connect(set_deferred.bind("tweening", false))
		
		move_and_slide()


func _on_timer_timeout() -> void:
	set_movement_target(global_position + Vector2(randf_range(-500, 500), randf_range(-500, 500)))


func _on_navigation_agent_2d_navigation_finished() -> void:
	$Timer.wait_time = randf_range(1, 4)
	$Timer.start()

func _die(health,from):
	active = false
	queue_free()

func _on_misc_sound_timer_timeout() -> void:
	$OinkSound.play()
	$MiscSoundTimer.wait_time = randf_range(1, 3)
	$MiscSoundTimer.start()
