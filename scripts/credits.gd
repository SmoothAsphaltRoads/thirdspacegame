extends Control

signal closed
const CREDITS := [
	["a game by", "Abhijnan Nanda & Harish Rusum"],
	["art", "handrawn by the team"],
	["music", "custom-made"],
	["engine", "godot 4"]
]

func _ready() -> void:
	for entry in CREDITS:
		%Entries.add_child(_make_entry(entry[0], entry[1]))
	%Back.pressed.connect(close)
	%Back.mouse_entered.connect(%Back.grab_focus)

func _make_entry(role: String, who: String) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separition", 0)
	
	var r := Label.new()
	r.text = role
	r.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	r.add_theme_font_size_override("font size", 16)
	r.add_theme_color_override("font_color", Color("9a86ab"))
	
	var n = Label.new()
	n.text = who
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	n.add_theme_font_size_override("font size", 24)
	n.add_theme_color_override("font_color", Color("f3dbc6"))
	
	box.add_child(r)
	box.add_child(n)
	return box

func open() -> void:
	visible = true
	%Back.grab_focus()

func close() -> void:
	visible = false
	closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()
