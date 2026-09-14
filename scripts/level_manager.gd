extends Node

@export var levels: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
]

var current_level := 0
func go_to_next_level() -> void:
	current_level = (current_level+1) % levels.size()
	change_scene(levels[current_level])

func restart_level() -> void:
	change_scene(levels[current_level])

func change_scene(path: String) -> void:
	await Transition.cover()
	get_tree().call_deferred("change_scene_to_file", path)
	await get_tree().process_frame
	await Transition.reveal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
