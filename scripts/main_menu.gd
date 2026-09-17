extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var start_button: Button = $MainButtons/Button
@onready var options_button: Button = $MainButtons/Button2
@onready var levels_button: Button = $MainButtons/Button3
@onready var options: Panel = $Options

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	levels_button.pressed.connect(_on_levels_pressed)
	main_buttons.visible = true
	options.visible = false


func _on_start_pressed() -> void:
	LevelManager.start_game()

func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true


func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_back_options_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
