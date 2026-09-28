extends Node

var levels: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
	"res://scenes/levels/level_3.tscn",
	"res://scenes/levels/level_4.tscn",
	"res://scenes/levels/level_5.tscn",
	"res://scenes/levels/level_6.tscn",
	"res://scenes/levels/level_7.tscn",
	"res://scenes/levels/level_8.tscn",
	"res://scenes/levels/level_9.tscn",
	"res://scenes/levels/level_10.tscn",
	"res://scenes/levels/level_11.tscn"
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
	20,
	20,
	20,
	20,
	10
]

var is_changing := false
var time_taken := 0.0
var level_stars := {}
const SAVE := "user://savegame.cfg"
func stars_calc (time: float) -> int:
	if time <= 5.0:
		return 3
	elif time <= 10.0:
		return 2
	else:
		return 1
func start_game() -> void:
	change_scene(levels[0])
func star_save () -> void:
	var config := ConfigFile.new()
	config.set_value("data", "stars", level_stars)
	config.save(SAVE)
func star_load () -> void:
	var config := ConfigFile.new()
	if config.load(SAVE) == OK:
		level_stars = config.get_value("data", "stars", {})
var current_level := 0
func go_to_next_level() -> void:
	if is_changing:
		return
	current_level += 1
	if (current_level % levels.size()==0):
		current_level = 0
		change_scene("res://scenes/ending.tscn")
		return
	current_level = current_level % levels.size()
	if is_changing:
		return
	is_changing = true
	await Transition.cover()
	get_tree().call_deferred("change_scene_to_file", levels[current_level])
	await get_tree().process_frame
	var stars = stars_calc(time_taken)
	var level_idx = current_level - 1
	if not level_stars.has(level_idx) or stars > level_stars[level_idx]:
		level_stars[level_idx] = stars
		star_save()
	var stars_text = "⭐"
	if stars == 3:
		stars_text = "⭐⭐⭐"
	elif stars == 2:
		stars_text = "⭐⭐"
		
	await Showtime.show_text("Level %d\nTime: %.1fs  %s" % [current_level + 1, time_taken, stars_text], 1.8)
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
	star_load()

func _process(delta: float) -> void:
	pass
