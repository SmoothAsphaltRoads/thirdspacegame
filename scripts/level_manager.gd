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
var best_times := {}
var level_deaths := 0
const SAVE := "user://savegame.cfg"
var music_player := AudioStreamPlayer.new()
func stars_calc (time: float) -> int:
	if time <= 5.0:
		return 3
	elif time <= 10.0:
		return 2
	else:
		return 1
func start_game() -> void:
	play_music()
	change_scene(levels[0])
func star_save () -> void:
	var config := ConfigFile.new()
	config.set_value("data", "stars", level_stars)
	config.set_value("data", "best", best_times)
	config.save(SAVE)
func star_load () -> void:
	var config := ConfigFile.new()
	if config.load(SAVE) == OK:
		level_stars = config.get_value("data", "stars", {})
		best_times = config.get_value("data", "best", {})
var current_level := 0
func go_to_next_level() -> void:
	if is_changing:
		return
	current_level += 1
	level_deaths = 0
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
	await Transition.reveal()
	is_changing = false

func load_level(index : int) -> void:
	if is_changing:
		return
	play_music()
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
func play_music() -> void:
	if not (music_player.playing):
		music_player.play()
func stop_music() -> void:
	music_player.stop()
func _ready() -> void:
	star_load()
	music_player.stream = preload("res://assets/sounds/music.ogg")
	music_player.bus = &"Music"
	add_child (music_player)
func _process(delta: float) -> void:
	pass
