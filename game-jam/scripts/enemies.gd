extends Node2D

@export var speed: float = 100.0
@export var damage: int = 1
@export var player: Control   # drag your player node into this in the editor

@onready var hitbox: Area2D = $Area2D

func _ready() -> void:
	# Connect the area_entered signal so we can damage the player
	hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if player:
		# Move towards the player
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# If the body is the player, deal damage
	if body == player and body.has_method("take_damage"):
		body.take_damage(damage)
