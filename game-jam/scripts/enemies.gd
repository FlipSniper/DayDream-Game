extends Node2D

@export var speed: float = 100.0
@export var damage: int = 1
@export var max_health: int = 5
var current_health: int

@export var health_ui: Control   # drag your Health UI node here
@export var player: CharacterBody2D

@onready var hitbox: Area2D = $Area2D

func _ready() -> void:
	current_health = max_health
	# Connect hitbox signal
	hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta

# --- Damage Player ---
func _on_body_entered(body: Node) -> void:
	if body == player:
		health_ui.take_damage(damage)

# --- Enemy takes damage ---
func take_damage(amount: int) -> void:
	print(current_health)
	current_health -= amount
	if current_health <= 0:
		_die()

# --- Handle Enemy Death ---
func _die() -> void:
	print("Enemy died:", self.name)
	queue_free()  # remove enemy from the scene
