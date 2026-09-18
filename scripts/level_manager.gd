extends Node

var levels: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
	"res://scenes/levels/level_3.tscn",
	"res://scenes/levels/level_4.tscn",
	"res://scenes/levels/level_5.tscn",
	"res://scenes/levels/level_6.tscn",
	"res://scenes/levels/level_7.tscn",
]
var menus: Array[String] = [
	"res://scenes/main_menu.tscn"
]
var total_time: Array[int] = [
	10,
	20,
	20,
	30,
	20,
	20,
]

var is_changing := false
var time_left := 0.0

func start_game() -> void:
	change_scene(levels[0])

var current_level := 0
func go_to_next_level() -> void:
	if is_changing:
		return
	current_level += 1
	current_level = current_level % levels.size()
	if is_changing:
		return
	is_changing = true
	await Transition.cover()
	get_tree().call_deferred("change_scene_to_file", levels[current_level])
	await get_tree().process_frame
	await Showtime.show_text("Time taken: %.1f seconds" % (total_time[current_level-1] - time_left), 1)
	await Showtime.show_text("Level : " + str(current_level+1), 1.0)
	await Transition.reveal()
	is_changing = false

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
