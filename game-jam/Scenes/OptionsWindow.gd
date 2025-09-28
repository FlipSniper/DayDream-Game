extends Window

# --- nodes (mark Grid and Close with the blue bookmark in the editor) ---
@onready var grid: GridContainer = %Grid
@onready var close_btn: Button    = %Close

# --- actions to display ---
var actions: Array[String] = [
	"move_left", "move_right", "jump", "dash", "attack", "pause"
]

func _ready() -> void:
	hide()                         # start hidden
	if close_btn:
		close_btn.pressed.connect(_on_Close_pressed)
	if grid:
		grid.columns = 2
		_populate_controls()
	else:
		push_error("OptionsWindow: %Grid not found. Rename your GridContainer to 'Grid' and mark it as Unique Name.")

# Toggle visibility on/off
func toggle_visibility() -> void:
	if visible:
		hide()
	else:
		show()

func _populate_controls() -> void:
	if grid == null:
		return
	for c in grid.get_children():
		c.queue_free()

	for a in actions:
		var name_label := Label.new()
		name_label.text = a.capitalize().replace("_"," ")

		var bind_label := Label.new()
		bind_label.text = _action_to_string(a)

		grid.add_child(name_label)
		grid.add_child(bind_label)

func _action_to_string(action: String) -> String:
	var evs := InputMap.action_get_events(action)
	if evs.is_empty():
		return "Unbound"

	var parts: Array[String] = []
	for e in evs:
		if e is InputEventKey:
			parts.append(OS.get_keycode_string(e.get_physical_keycode_with_modifiers()))
		elif e is InputEventMouseButton:
			parts.append("Mouse " + str(e.button_index))
		elif e is InputEventJoypadButton:
			parts.append("Pad Btn " + str(e.button_index))
		elif e is InputEventJoypadMotion:
			parts.append("Pad Axis " + str(e.axis))
	return ", ".join(parts)

func _on_Close_pressed() -> void:
	hide()
