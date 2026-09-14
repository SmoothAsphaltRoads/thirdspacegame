extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var start_button: Button = $VBoxContainer/Button
@onready var options_button: Button = $VBoxContainer/Button2
@onready var exit_button: Button = $VBoxContainer/Button3

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _on_start_pressed() -> void:
	LevelManager.start_game()

func _on_options_pressed() -> void:
	print("open options menu")


func _on_exit_pressed() -> void:
	get_tree().quit()
