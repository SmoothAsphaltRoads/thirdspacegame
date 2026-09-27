extends CanvasLayer

@onready var speed_boost: Button = $HBoxContainer/speed_boost
@onready var jump_boost: Button = $HBoxContainer/jump_boost
@onready var shield_button: Button = $HBoxContainer/shield_button
@onready var start_button: Button = get_node_or_null("start")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true


func _start_game() -> void:

	get_tree().paused = false
	queue_free()

func _on_start_pressed() -> void:

	_start_game()

func _on_speed_pressed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
			player.speed_multiplier = 1.5
	_start_game()

func _on_jump_selected() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
			player.jump_multiplier = 1.3
	_start_game()

func _on_shield_selected() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_invincible = true
	_start_game()
