extends CharacterBody2D

const SPEED = 300.0

# Attack control
var can_attack: bool = true
var attack_type: String = "slash"  # can be "slash" or "beam"

func _physics_process(delta: float) -> void:
	# Movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * SPEED
	move_and_slide()

func _input(event):
	# Switch attack type
	if event.is_action_pressed("Basic"):
		attack_type = "slash"
	elif event.is_action_pressed("Ability1"):
		attack_type = "beam"

	# Attack input
	if event.is_action_pressed("attack") and can_attack:
		if attack_type == "slash":
			Slash()
		elif attack_type == "beam":
			Beam()

# --- ATTACKS ---

func Slash() -> void:
	can_attack = false
	$AnimationPlayer.play("slash")
	$Slash/sword/Area2D.monitoring = true

func Beam() -> void:
	can_attack = false
	# TODO: Replace "slash" with a real "beam" animation when you make one
	$AnimationPlayer.play("beam")
	# TODO: Instead of sword hitbox, spawn a projectile or enable beam Area2D
	print("Beam attack triggered (not implemented yet).")

# --- SIGNALS ---

func _on_SwordHitbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash" or anim_name == "beam":
		$Slash/sword/Area2D.monitoring = false
		can_attack = true
