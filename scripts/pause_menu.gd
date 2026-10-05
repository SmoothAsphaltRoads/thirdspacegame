extends CanvasLayer

@onready var panel: Control = $Center/Panel
@onready var buttons: VBoxContainer = $Center/Panel/Vbox/PauseButtons
@onready var resume: Button = $Center/Panel/Vbox/PauseButtons/Resume
@onready var options_button: Button = $Center/Panel/Vbox/PauseButtons/Options
@onready var options_panel: Control = $Center/OptionsPanel
@onready var back_button: Button = $Center/OptionsPanel/VBox/Buttons/BackButton

func _ready() -> void:
	visible = false
	get_tree().paused = false
	panel.visible = true
	options_panel.visible = false

	for b in buttons.get_children():
		if b is Button:
			b.focus_entered.connect(_on_focus.bind(b))
			b.focus_exited.connect(_on_unfocus.bind(b))
			b.mouse_entered.connect(b.grab_focus)

	back_button.focus_entered.connect(_on_focus.bind(back_button))
	back_button.focus_exited.connect(_on_unfocus.bind(back_button))
	back_button.mouse_entered.connect(back_button.grab_focus)

func open_menu() -> void:
	visible = true
	get_tree().paused = true
	panel.visible = true
	options_panel.visible = false
	resume.grab_focus()

func close_menu() -> void:
	visible = false
	options_panel.visible = false
	panel.visible = true
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if options_panel.visible:
			_on_options_back_pressed()
		elif visible:
			close_menu()
		else:
			open_menu()
		get_viewport().set_input_as_handled()

func _on_focus(b: Button) -> void:
	b.add_theme_stylebox_override("normal", b.get_theme_stylebox("hover"))

func _on_unfocus(b: Button) -> void:
	b.remove_theme_stylebox_override("normal")

func _on_button_pressed() -> void:
	close_menu()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/startscreen.tscn")

func _on_options_pressed() -> void:
	panel.visible = false
	options_panel.visible = true
	back_button.grab_focus()

func _on_options_back_pressed() -> void:
	options_panel.visible = false
	panel.visible = true
	options_button.grab_focus()

func _on_levels_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
