extends Control

const node_open := preload("res://assets/ui/node_open.png")
const node_done := preload("res://assets/ui/node_done.png")
const node_locked := preload("res://assets/ui/node_locked.png")
const lock := preload("res://assets/ui/icon_lock.png")
const star := preload("res://assets/ui/icon_star.png")
const node_size := 72.0
const worlds := [
	{"name": "the woods", "bg": preload("res://assets/background/Green.png")},
	{"name": "sunset ridge", "bg": preload("res://assets/background/Gray.png")},
	{"name": "the hollow", "bg": preload("res://assets/background/Brown.png")}]
	
const spots := [
		[Vector2(330, 650), Vector2(640, 520), Vector2(960, 610), Vector2(1280, 480), Vector2(1590, 570)],
		[Vector2(330, 520), Vector2(640, 640), Vector2(960, 500), Vector2(1280, 630), Vector2(1590, 480)],
		[Vector2(330, 560), Vector2(640, 680), Vector2(960, 560), Vector2(1280, 690), Vector2(1590, 580)],
	]
	
@onready var bg: TextureRect = $Bg
@onready var map: Control = $Map
@onready var walker: AnimatedSprite2D = $Walker
@onready var world_num: Label = $Header/WorldNum
@onready var world_name: Label = $Header/WorldName
@onready var arrow_l: TextureButton = $ArrowL
@onready var arrow_r: TextureButton = $ArrowR
@onready var total_label: Label = $Total/Count
@onready var info_tag: Label = $Info/HBox/Left/Tag
@onready var info_name: Label = $Info/HBox/Left/Name
@onready var info_stars: HBoxContainer = $Info/HBox/Left/Stars
@onready var info_best: Label = $Info/HBox/Mid/Best
@onready var info_par: Label = $Info/HBox/Mid/Par
@onready var hint: Label = $Info/HBox/Play
@onready var back: Button = $Back
@onready var node_buttons: Array[TextureButton] = [
	$Map/Node1, $Map/Node2, $Map/Node3, $Map/Node4, $Map/Node5
]
var _sel := 0
var _world := 0
var _busy := false

func _ready() -> void:
	for btn in node_buttons:
		btn.focus_mode = Control.FOCUS_NONE
	arrow_l.focus_mode = Control.FOCUS_NONE
	arrow_r.focus_mode = Control.FOCUS_NONE
	_sel = LevelManager.current_level
	_world = _sel / 5
	_world = clampi(_world, 0, worlds.size() - 1)
	map.draw.connect(_draw_path)
	_update_total_stars()
	_update_world()
	_place_walker(true)
	_update_info()
	
func _update_total_stars() -> void:
	var total := 0
	for i in LevelManager.level_stars:
		total += LevelManager.level_stars[i]
	total_label.text = "%d/45" % total
	
func _update_world() -> void:
	var w: Dictionary = worlds[_world]
	bg.texture = w.bg
	world_num.text = "world %d" % (_world + 1)
	world_name.text = w.name 
	arrow_l.visible = _world > 0
	arrow_r.visible = _world < worlds.size() - 1
	for i in 5:
		var btn := node_buttons[i]
		var level_idx := _world * 5 + i
		btn.size = Vector2(node_size, node_size)
		btn.position = spots[_world][i] - Vector2(node_size, node_size) / 2.0
		var unlocked := _is_level_unlocked(level_idx)
		var stars: int = LevelManager.level_stars.get(level_idx, 0)
		btn.texture_normal = node_locked if not unlocked else (node_done if stars > 0 else node_open)
		if btn.has_node("Number"):
			var num_lbl: Label = btn.get_node("Number")
			num_lbl.visible = true
			num_lbl.text = str(level_idx + 1)
			num_lbl.modulate = Color.WHITE if unlocked else Color(1, 1, 1, 0.4)
		
		if btn.has_node("Lock"):
			btn.get_node("Lock").visible = not unlocked
			
		if btn.has_node("Stars"):
			var stars_box: HBoxContainer = btn.get_node("Stars")
			stars_box.visible = unlocked
			var star_nodes := stars_box.get_children()
			for s in star_nodes.size():
				star_nodes[s].modulate = Color.WHITE if s < stars else Color(1, 1, 1, 0.25)
	map.queue_redraw()
			
func _draw_path() -> void:
	var spots_list: Array = spots[_world]
	for i in spots_list.size() - 1:
		var a: Vector2 = spots_list[i]
		var b: Vector2 = spots_list[i + 1]
		var open := _is_level_unlocked(_world * 5 + i + 1)
		var col := Color("f3dbc6", 0.75) if open else Color("683a68", 0.8)
		var dist := a.distance_to(b)
		var steps := int(dist / 27.0)
		for s in range(1, steps):
			var p := a.lerp(b, float(s) / steps)
			p.y -= sin(float(s) / steps * PI) * 24.0
			var too_close := false
			for spot in spots_list:
				if p.distance_to(spot) < 65.0:
					too_close = true
					break
			if too_close:
				continue
			p = (p / 3.0).round() * 3.0
			map.draw_rect(Rect2(p - Vector2(4.5, 4.5), Vector2(9, 9)), Color("1b0f1e"))
			map.draw_rect(Rect2(p - Vector2(3, 3), Vector2(6, 6)), col)

func _is_level_unlocked(idx: int) -> bool:
	if idx == 0:
		return true
	return LevelManager.level_stars.has(idx - 1)

func _select_spot(local_idx: int) -> void:
	if _busy:
		return
	var global_idx := _world * 5 + local_idx
	if not _is_level_unlocked(global_idx):
		return
	if global_idx == _sel:
		_start_level(global_idx)
		return
	var from := walker.position
	_sel = global_idx
	_update_info()
	_place_walker(false, from)

func _place_walker(instant: bool, from := Vector2.ZERO) -> void:
	var local := _sel % 5
	var target: Vector2 = spots[_world][local] + Vector2(0, -node_size / 2.0 - 36)
	var suffix := "1" if _world == 0 else "2"
	if instant:
		walker.position = target
		if walker.sprite_frames != null and walker.sprite_frames.has_animation("idle" + suffix):
			walker.play("idle" + suffix)
		return
	_busy = true
	walker.flip_h = target.x < from.x
	if walker.sprite_frames != null and walker.sprite_frames.has_animation("jump" + suffix):
		walker.play("jump" + suffix)
	var tween := create_tween()
	tween.tween_method(func(t: float):
		walker.position = from.lerp(target, t) + Vector2(0, -sin(t * PI) * 60.0), 0.0, 1.0, 0.28)
	await tween.finished
	if walker.sprite_frames != null and walker.sprite_frames.has_animation("idle" + suffix):
		walker.play("idle" + suffix)
	create_tween().tween_property(walker, "scale", Vector2(3, 3), 0.15)
	_busy = false

func _update_info() -> void:
	var local := _sel % 5
	info_tag.text = "%d-%d" % [_world + 1, local + 1]
	info_name.text = "Level %d" % (_sel + 1)
	if LevelManager.best_times.has(_sel):
		info_best.text = "best %.2fs" % LevelManager.best_times[_sel]
	else:
		info_best.text = "best --"
	if _sel < LevelManager.total_time.size():
		info_par.text = "par %ds" % LevelManager.total_time[_sel]
	else:
		info_par.text = "par --"
	var stars: int = LevelManager.level_stars.get(_sel, 0)
	if info_stars:
		var star_nodes := info_stars.get_children()
		for s in star_nodes.size():
			star_nodes[s].modulate = Color.WHITE if s < stars else Color(1, 1, 1, 0.25)

func _start_level(idx: int) -> void:
	if idx < LevelManager.levels.size():
		LevelManager.load_level(idx)

func _on_arrow_l_pressed() -> void:
	if _busy or _world <= 0:
		return
	_world -= 1
	_sel = _world * 5
	_update_world()
	_place_walker(true)
	_update_info()

func _on_arrow_r_pressed() -> void:
	if _busy or _world >= worlds.size() - 1:
		return
	_world += 1
	_sel = _world * 5
	_update_world()
	_place_walker(true)
	_update_info()

func _on_node_1_pressed() -> void:
	_select_spot(0)

func _on_node_2_pressed() -> void:
	_select_spot(1)

func _on_node_3_pressed() -> void:
	_select_spot(2)

func _on_node_4_pressed() -> void:
	_select_spot(3)

func _on_node_5_pressed() -> void:
	_select_spot(4)

func _on_back_pressed() -> void:
	LevelManager.change_scene("res://scenes/startscreen.tscn")

func _input(event: InputEvent) -> void:
	if LevelManager.is_changing:
		return
	if event.is_action_pressed("ui_right"):
		_move(1)
	elif event.is_action_pressed("ui_left"):
		_move(-1)
	elif event.is_action_pressed("ui_accept"):
		_start_level(_sel)
	elif event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			_on_arrow_l_pressed()
		elif event.keycode == KEY_E:
			_on_arrow_r_pressed()

func _move(dir: int) -> void:
	if _busy:
		return
	var local := _sel % 5
	var new_local := local + dir
	if new_local < 0:
		if _world > 0:
			_on_arrow_l_pressed()
			_select_spot(4)
		return
	elif new_local > 4:
		if _world < worlds.size() - 1:
			_on_arrow_r_pressed()
			_select_spot(0)
		return
	_select_spot(new_local)
