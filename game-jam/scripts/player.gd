extends CharacterBody2D

const SPEED = 300.0
@onready var sacrifice = 0
# Attack control
var can_attack: bool = true
var attack_type: String = "slash"  # can be "slash" or "beam"


func _ready() -> void:
	# Make sure only the default attack is visible at start
	$Beam.visible = false
	$Slash.visible = true

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	# Use your custom input maps
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Normalize diagonal movement
	if input_vector.length() > 0:
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
		if attack_type == "slash" and sacrifice <= 1:
			Slash()
		elif attack_type == "beam" and sacrifice <= 0:
			Beam()

# --- HELPER FUNCTIONS ---
func _set_attack_type(new_type: String) -> void:
	attack_type = new_type
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
	print(body.get_parent().has_method("take_damage"))
	if body.has_method("take_damage"):
		if attack_type == "slash":
			body.get_parent().take_damage(1)
		elif attack_type == "beam":
			body.get_parent().take_damage(2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["slash", "beam"]:
		$Slash/Area2D.monitoring = false
		$Beam/Area2D.monitoring = false
		can_attack = true
