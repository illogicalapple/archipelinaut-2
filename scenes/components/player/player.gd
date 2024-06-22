extends CharacterBody2D

@export var speed : float
@onready var animTree = $AnimationTree

var facing_last = 1
var blend_amount = 0.0
var target_blend_amount = 1.0
const BLEND_SPEED = 5.0

func _physics_process(delta: float) -> void:
	# Main movement 
	var movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movement_direction * speed
	move_and_slide()
	
	# Change direction the character is facing
	var facing_dir = movement_direction.sign().x
	if facing_dir != 0 && facing_dir != facing_last:
		scale.x *= -1
		facing_last = facing_dir

	# Play bobbing animation if moving
	if velocity != Vector2.ZERO:
		target_blend_amount = 0.0
	else:
		target_blend_amount = 1.0
		
	blend_amount = lerp(blend_amount, target_blend_amount, delta * BLEND_SPEED)
	animTree.set("parameters/walk_idle/blend_amount", blend_amount)
