extends Control

@onready var rows: VBoxContainer = $MarginContainer/VBoxContainer
@onready var level_1: Button = $MarginContainer/VBoxContainer/row1/Level1
func _ready() -> void:
	var index := 0
	for row in rows.get_children():
		for button in row.get_children():
			if button is Button:
				var text = str(index+1)
				if LevelManager.level_stars.has (index):
					var stars = LevelManager.level_stars[index]
					if stars == 3:
						text += "\n⭐⭐⭐"
					elif stars == 2:
						text += "\n⭐⭐"
					elif stars == 1:
						text += "\n⭐"
				button.text = text
				if index < LevelManager.levels.size():
					button.pressed.connect(LevelManager.load_level.bind(index))
				else:
					button.disabled = true
				index += 1
	level_1.grab_focus()
