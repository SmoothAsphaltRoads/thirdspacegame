extends Node

const TRACKS := {
	"menu": preload("res://assets/music/track1_drift.ogg"),
	1: preload("res://assets/music/track1_drift.ogg"),
	2: preload("res://assets/music/track2_wander.ogg"),
	3: preload("res://assets/music/track3_rush.ogg"),
	4: preload("res://assets/music/track4_overdrive.ogg"),
}

const WORLD_STARTS := [1, 5, 9, 13]

const FADE := 0.6
var player: AudioStreamPlayer
var current: AudioStream

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = AudioStreamPlayer.new()
	if AudioServer.get_bus_index("Music") != -1:
		player.bus = "Music"
	add_child(player)
	for s in TRACKS.values():
		s.loop = true

func play_menu() -> void:
	_play(TRACKS["menu"])

func play_world(world: int) -> void:
	_play(TRACKS.get(world, TRACKS["menu"]))

func play_for_level(level_number: int) -> void:
	var world := 1
	for i in WORLD_STARTS.size():
		if level_number >= WORLD_STARTS[i]:
			world = i + 1
	play_world(world)

func stop() -> void:
	current = null
	create_tween().tween_property(player, "volume_db", -40.0, FADE)

func _play(stream: AudioStream) -> void:
	if stream == current and player.playing:
		return 
	current = stream
	var t := create_tween()
	if player.playing:
		t.tween_property(player, "volume_db", -40.0, FADE * 0.5)
	t.tween_callback(func():
		player.stream = stream
		player.volume_db = -40.0
		player.play())
	t.tween_property(player, "volume_db", 0.0, FADE)
