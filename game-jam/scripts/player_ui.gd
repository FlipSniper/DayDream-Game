extends Control

# Max and current health
@export var max_health: int = 10
var current_health: int = 10

# Link to the player node
@export var player: CharacterBody2D

# Reference to the Label node in your scene
@onready var health_label: Label = $health  # make sure your node is a Label

func _ready() -> void:
	current_health = max_health
	_update_health_label()

# Call this function to deal damage
func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	_update_health_label()
	
	# Check for sacrifice logic
	if current_health <= 0:
		player.sacrifice += 1   # ✅ directly increment
		current_health = max_health  # reset health after sacrifice
		_update_health_label()
		
		# If player has reached 3 sacrifices, trigger death
		if player.sacrifice >= 3:
			_die()

# Optional: heal function
func heal(amount: int) -> void:
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	_update_health_label()

# Update the Label UI
func _update_health_label() -> void:
	if health_label:
		health_label.text = str(current_health, " / ", max_health)

# Handle death
func _die() -> void:
	print("Player is dead")
	# Add more death logic here, e.g., reload scene or show game over
