extends Control

@onready var rows: VBoxContainer = $MarginContainer/VBoxContainer

func _ready() -> void:
	var index := 0
	for row in rows.get_children():
		for button in row.get_children():
			if button is Button:
				button.text = str(index+1)
				if index < LevelManager.levels.size():
					button.pressed.connect(LevelManager.load_level.bind(index))
				else:
					button.disabled = true
				index += 1
