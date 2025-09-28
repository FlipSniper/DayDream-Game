extends Control

func _ready():
	pass

	

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


# OptionsWindow.gd (same node as before)
func _on_options_pressed() -> void:
	$CanvasLayer/VBoxContainer/OptionsWindow.toggle_visibility()
	
func _on_exit_pressed() -> void:
	get_tree().quit()
