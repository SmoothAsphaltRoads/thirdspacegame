extends OptionButton

func _ready() -> void:
	var options = [2.0, 1.75, 1.5, 1.25, 1.0, 0.75, 0.5, 0.25]
	var current_scale = get_tree().root.content_scale_factor
	for i in options.size():
		if is_equal_approx(options[i], current_scale):
			selected = i
			break

func _on_item_selected(index: int) -> void:
	var options = [2.0, 1.75, 1.5, 1.25, 1.0, 0.75, 0.5, 0.25]
	var value = options[index]
	get_tree().root.content_scale_factor = value
