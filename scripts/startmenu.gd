extends Node2D

var SLIDE := 12.0

var targets := {
	"Start": "res://scenes/levels/level_1.tscn",
	"Levels": "res://scenes/level_select.tscn",
	"Options": "res://scenes/options.tscn",
}

@onready var buttons: VBoxContainer = %Buttons
func _ready() -> void:
	for b: Button in buttons.get_children():
		b.focus_entered.connect(_on_focus.bind(b))
		b.focus_exited.connect(_on_unfocus.bind(b))
		b.mouse_entered.connect(b.grab_focus)
		b.pressed.connect(_on_pressed.bind(b))

	await get_tree().process_frame
	buttons.get_child(0).grab_focus()

func _on_pressed(b: Button) -> void:
	if b.name == "Quit":
		get_tree().quit()
		return
	var path: String = targets.get(String(b.name), "")
	get_tree().change_scene_to_file(path)

func _on_focus(b: Button) -> void:
	b.add_theme_stylebox_override("normal", b.get_theme_stylebox("hover"))
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).tween_property(b, "position:x", SLIDE, 0.08)

func _on_unfocus(b: Button) -> void:
	b.remove_theme_stylebox_override("normal")
	create_tween().tween_property(b, "position:x", 0.0, 0.08)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
