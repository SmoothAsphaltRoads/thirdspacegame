extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
func on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")
func on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")
