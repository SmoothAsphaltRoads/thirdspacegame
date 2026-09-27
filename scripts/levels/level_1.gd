extends Node
@onready var timer: Label = $timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer := get_tree().current_scene.get_node("timer")
	LevelManager.time_left = timer.timeLeft

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
