extends CharacterBody2D

const SPEED = 300.0

# Attack cooldown so you can’t spam
var can_attack: bool = true

func _physics_process(delta: float) -> void:
	# Movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * SPEED
	move_and_slide()

func _input(event):
	# Attack input
	if event.is_action_pressed("attack") and can_attack:
		_attack()

func _attack() -> void:
	can_attack = false
	$AnimationPlayer.play("slash")
	# Enable sword hitbox only while attack is active
	$Slash/sword/Area2D.monitoring = true

# Sword hit detection
func _on_SwordHitbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(1) # deal 1 damage (tweak as needed)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash":
		$Slash/sword/Area2D.monitoring = false
		can_attack = true
