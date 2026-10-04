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
		"card": preload("res://assets/ui/powerup-jump.png")
	},
	"dash": {
		"cost": 5.0,
		"card": preload("res://assets/ui/powerup-dash.png")
	}
}

@onready var cards = [$Cards/Card1, $Cards/Card2, $Cards/Card3]
@onready var start: Button = $Bottom/start



var rest_y := {}

func _ready() -> void:
	get_tree().paused = true
	var keys = boosts.keys()
	keys.shuffle()
	var picked = keys.slice(0, 3)

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

	await get_tree().process_frame
	for card in cards:
		rest_y[card] = card.position.y

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
	var timer = get_tree().get_first_node_in_group("level_timer")
	if timer:
		timer.reduce_time(cost)
	_close()

func _close() -> void:
	get_tree().paused = false
	queue_free()
