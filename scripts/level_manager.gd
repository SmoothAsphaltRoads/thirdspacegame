extends Node

@export var levels: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
	"res://scenes/levels/level_3.tscn",
	"res://scenes/levels/level_4.tscn",
]

@export var menus: Array[String] = [
	"res://scenes/main_menu.tscn"
]

var is_changing := false

func start_game() -> void:
	change_scene(levels[0])

var current_level := 0
func go_to_next_level() -> void:
	if is_changing:
		return
	current_level += 1
	current_level = current_level % levels.size()
	change_scene(levels[current_level])

func load_level(index : int) -> void:
	if is_changing:
		return
	current_level = index % levels.size()
	change_scene(levels[current_level])
	

func restart_level() -> void:
	change_scene(levels[current_level])

func change_scene(path: String) -> void:
	if is_changing:
		return
	is_changing = true
	await Transition.cover()
	get_tree().call_deferred("change_scene_to_file", path)
	await get_tree().process_frame
	await Transition.reveal()
	is_changing = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
