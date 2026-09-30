extends Node
@onready var top: ColorRect = $top
@onready var bottom: ColorRect = $bottom
@onready var text: Label = $text
@onready var box: HBoxContainer = $skip
@onready var fill: ColorRect = $skip/Bar/fill

const BAR_HEIGHT := 132.0
const SKIP_TIME := 0.8

var skipped := false
var _hold := 0.0
var _done := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = ""
	box.modulate.a = 0.4
	_run()

func _run() -> void:
	await _wait(0.4)
	await bars(true)
	await say("hello.")
	await say("this is the intro.", 1.0)
	_end()

func bars(show: bool, time := 0.5) -> void:
	var height := BAR_HEIGHT if show else 0.0
	var tween := create_tween().set_parallel().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(top, "size:y", height, time)
	tween.tween_property(bottom, "size:y", height, time)
	tween.tween_property(bottom, "position:y", 1080.0-height, time)
	await tween.finished

func _wait(t: float) -> void:
	if skipped:
		return
	await get_tree().create_timer(t).timeout


func say(line: String, hold := 1.4) -> void:
	if skipped:
		return
	text.text = line
	text.visible_characters = 0
	text.modulate.a = 1.0
	
	for i in line.length():
		text.visible_characters = i+1
		await _wait(0.04)
	await _wait(hold)
	var tween := create_tween()
	tween.tween_property(text, "modulate:a", 0.0, 0.3)
	await tween.finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel") or Input.is_action_pressed("ui_accept"):
		_hold += delta
	else:
		_hold = maxf(_hold - delta * 2.0, 0.0)
	box.modulate.a = move_toward(box.modulate.a, 1.0 if _hold > 0.0 else 0.4, delta * 4.0)
	var full := (fill.get_parent() as Control).size.x - 6.0
	fill.size.x  = full * clampf(_hold / SKIP_TIME, 0.0, 1.0)
	if _hold >= SKIP_TIME and not skipped:
		skipped = true
		_end()
		
func _end() -> void:
	if _done:
		return
	_done = true
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
