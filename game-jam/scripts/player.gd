extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	# Get movement input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Normalize so diagonal movement isn’t faster
	input_vector = input_vector.normalized()
	
	# Apply movement
	velocity = input_vector * SPEED
	move_and_slide()
