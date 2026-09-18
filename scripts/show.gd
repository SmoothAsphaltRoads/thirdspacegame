extends CanvasLayer

@onready var label: Label = $Label

func _ready() -> void:
	visible = false

func show_text(value: String, duration := 10.0) -> void:
	label.text = str(value)
	visible = true
	await get_tree().create_timer(duration).timeout
	print("showing: '", label.text, "' label_vis=", label.visible, " layer_vis=", visible, " size=", label.size, " pos=", label.global_position)
	visible = false
