extends CanvasLayer
@onready var options: Panel = $PauseButtons/Options/Options

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	visible = false
	get_tree().paused = false
	options.visible = false
	

func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
func _input(event:InputEvent) ->void :
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_options_pressed() -> void:
	options.visible = true
	
