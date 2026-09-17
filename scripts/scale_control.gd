extends OptionButton



func _on_item_selected(index: int) -> void:
	var options = [2, 1.75, 1.5, 1.25, 1, 0.75, 0.5, 0.25]
	var value = options[index]
	print(value)
	get_tree().root.content_scale_factor = value
	
