extends CanvasLayer

const RISE := 12.0
const OUTLINE_COLOR := Color("f2b8a0")

const boosts = {
	"speed": {
		"cost": 5.0,
		"card": preload("res://assets/ui/powerup-speed.png")
	},
	"jump": {
		"cost": 4.0,
		"card": preload("res://assets/ui/powerup-jump.png")
	},
	"shield": {
		"cost": 5.0,
		"card": preload("res://assets/ui/powerup-shield.png")
	},
	"glide": {
		"cost": 3.0,
		"card": preload("res://assets/ui/powerup-featherfalling.png")
	},
	"double_jump": {
		"cost": 6.0,
		"card": preload("res://assets/ui/powerup-doublejump.png")
	},
	"dash": {
		"cost": 5.0,
		"card": preload("res://assets/ui/powerup-dash.png")
	}
}

@onready var cards = [$Cards/Card1, $Cards/Card2, $Cards/Card3]
@onready var start: Button = $Bottom/start

var rest_y := {}
var _picked_ids: Array = []

func _ready() -> void:
	get_tree().paused = true
	var keys = boosts.keys()
	keys.shuffle()
	var picked = keys.slice(0, 3)
	_picked_ids = picked

	for i in 3:
		var id = picked[i]
		var data = boosts[id]
		var card = cards[i]
		card.texture_normal = data.card
		card.pressed.connect(_choose.bind(id, data.cost))
		card.add_child(_make_outline())
		card.mouse_entered.connect(card.grab_focus)
		card.focus_entered.connect(_card_hover.bind(card, true))
		card.focus_exited.connect(_card_hover.bind(card, false))

		var key_lbl := Label.new()
		key_lbl.text = "[%d]" % (i + 1)
		key_lbl.add_theme_font_override("font", preload("res://fonts/Minecraft.ttf"))
		key_lbl.add_theme_font_size_override("font_size", 28)
		key_lbl.add_theme_color_override("font_color", Color("f3dbc6"))
		key_lbl.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		key_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		key_lbl.offset_bottom = -16
		card.add_child(key_lbl)

	if start:
		start.custom_minimum_size = Vector2(280, 60)
		if start.text.is_empty():
			start.text = "No boosts [4]"
		start.add_theme_font_override("font", preload("res://fonts/Minecraft.ttf"))
		start.add_theme_font_size_override("font_size", 32)
		if not start.pressed.is_connected(_close):
			start.pressed.connect(_close)
		start.mouse_entered.connect(start.grab_focus)

	await get_tree().process_frame
	for card in cards:
		rest_y[card] = card.position.y

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1, KEY_KP_1:
				_pick_index(0)
			KEY_2, KEY_KP_2:
				_pick_index(1)
			KEY_3, KEY_KP_3:
				_pick_index(2)
			KEY_4, KEY_KP_4, KEY_SPACE:
				_close()

func _pick_index(idx: int) -> void:
	if idx >= 0 and idx < _picked_ids.size():
		var id: String = _picked_ids[idx]
		var cost: float = boosts[id].cost
		_choose(id, cost)

func _make_outline() -> Panel:
	var sb := StyleBoxFlat.new()
	sb.draw_center = false
	sb.set_border_width_all(3)
	sb.border_color = OUTLINE_COLOR
	sb.set_expand_margin_all(6)
	sb.anti_aliasing = false
	var p := Panel.new()
	p.name = "HoverOutline"
	p.add_theme_stylebox_override("panel", sb)
	p.set_anchors_preset(Control.PRESET_FULL_RECT)
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.visible = false    
	return p

func _card_hover(card: Control, on: bool) -> void:
	if not rest_y.has(card):
		return
	card.get_node("HoverOutline").visible = on
	create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) \
		.tween_property(card, "position:y", rest_y[card] - (RISE if on else 0.0), 0.1)

func _choose(id: String, cost: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("apply_upgrade"):
		player.apply_upgrade(id)
	var indicator = get_tree().get_first_node_in_group("boost_indicator")
	if indicator:
		indicator.show_boost(id)
	var timer = get_tree().get_first_node_in_group("level_timer")
	if timer:
		timer.reduce_time(cost)
	_close()

func _on_start_pressed() -> void:
	_close()

func _close() -> void:
	get_tree().paused = false
	queue_free()
