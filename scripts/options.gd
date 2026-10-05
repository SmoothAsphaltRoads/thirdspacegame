extends Control

@onready var back_button: Button = $Center/PanelContainer/VBox/Buttons/BackButton

func _ready() -> void:
	back_button.grab_focus()
	back_button.pressed.connect(_on_back_pressed)
	back_button.focus_entered.connect(_on_focus.bind(back_button))
	back_button.focus_exited.connect(_on_unfocus.bind(back_button))
	back_button.mouse_entered.connect(back_button.grab_focus)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()

func _on_focus(b: Button) -> void:
	b.add_theme_stylebox_override("normal", b.get_theme_stylebox("hover"))

func _on_unfocus(b: Button) -> void:
	b.remove_theme_stylebox_override("normal")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/startscreen.tscn")
