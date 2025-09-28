extends CharacterBody2D

const SPEED = 300.0

# Attack control
var can_attack: bool = true
var attack_type: String = "slash"  # can be "slash" or "beam"

func _ready() -> void:
	$Beam.visible = false
	$Slash.visible = true

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
		_set_attack_type("slash")
	elif event.is_action_pressed("Ability1"):
		_set_attack_type("beam")

	# Attack input
	if event.is_action_pressed("attack") and can_attack:
		if attack_type == "slash":
			Slash()
		elif attack_type == "beam":
			Beam()

# --- HELPER FUNCTIONS ---

func _set_attack_type(new_type: String) -> void:
	attack_type = new_type
	# Show only the equipped attack
	$Slash.visible = attack_type == "slash"
	$Beam.visible = attack_type == "beam"

# --- ATTACKS ---

func Slash() -> void:
	can_attack = false
	$AnimationPlayer.play("slash")
	$Slash/Area2D.monitoring = true
	$Beam/Area2D.monitoring = false

func Beam() -> void:
	can_attack = false
	$AnimationPlayer.play("beam")
	$Beam/Area2D.monitoring = true
	$Slash/Area2D.monitoring = false

# --- SIGNALS ---

func _on_SwordHitbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		# Determine which attack is active for damage
		if attack_type == "slash":
			body.take_damage(1)  # Slash damage
		elif attack_type == "beam":
			body.take_damage(2)  # Beam damage (example)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "slash" or anim_name == "beam":
		$Slash/Area2D.monitoring = false
		$Beam/Area2D.monitoring = false
		can_attack = true
