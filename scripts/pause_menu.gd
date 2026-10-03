extends CanvasLayer

@onready var buttons: VBoxContainer = $Center/Panel/Vbox/PauseButtons
@onready var resume: Button = $Center/Panel/Vbox/PauseButtons/Resume
@onready var options_button: Button = $Center/Panel/Vbox/PauseButtons/Options
@onready var options_panel: Control = $Center/Panel/Vbox/PauseButtons/Options/OptionsPanel

func _ready() -> void:
	visible = false
	get_tree().paused = false
	options_panel.visible = false

	for b in buttons.get_children():
		if b is Button:
			b.focus_entered.connect(_on_focus.bind(b))
			b.focus_exited.connect(_on_unfocus.bind(b))
			b.mouse_entered.connect(b.grab_focus)

func open_menu() -> void:
	visible = true
	get_tree().paused = true
	options_panel.visible = false
	resume.grab_focus()

func close_menu() -> void:
	visible = false
	options_panel.visible = false
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if options_panel.visible:
			options_panel.visible = false
			options_button.grab_focus()
		elif visible:
			close_menu()
		else:
			open_menu()
		get_viewport().set_input_as_handled()

func _on_focus(b: Button) -> void:
	b.add_theme_stylebox_override("normal", b.get_theme_stylebox("hover"))

func _on_unfocus(b: Button) -> void:
	b.remove_theme_stylebox_override("normal")

func _on_button_pressed() -> void:   # Resume
	LevelManager.stop_music()
	close_menu()

func _on_quit_pressed() -> void:
	LevelManager.stop_music()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/startscreen.tscn")

func _on_options_pressed() -> void:
	options_panel.visible = true

func _on_levels_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
