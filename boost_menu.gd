extends CanvasLayer
const boosts = {
	"speed":{
		"cost" : 5.0,
		"card" : preload("res://assets/ui/powerup-speed.png")
	},
	"jump":{
		"cost":4.0,
		"card": preload("res://assets/ui/powerup-jump.png")
	},
	"shield":{
		"cost"=5.0,
		"card" = preload("res://assets/ui/powerup-shield.png")
	},
	"glide":{
		"cost" :3.0,
		"card": preload("res://assets/ui/featherpixart.jpg")
	},
	"double_jump":{
		"cost" = 6.0,
		"card" = preload("res://assets/ui/springpixart.webp")
	},
	"dash":{
		"cost" = 5.0,
		"card" =preload("res://assets/ui/dashpixart.jpg")
	}
}
@onready var cards = [$Cards/Card1,$Cards/Card2,$Cards/Card3]
@onready var start: Button = $Bottom/start

func _ready() -> void:
	get_tree().paused=true
	var keys = boosts.keys()
	keys.shuffle()
	var picked = keys.slice (0,3)
	
	for i in 3:
		var id = picked[i]
		var data = boosts[id]
		var card = cards[i]
		card.texture_normal = data.card
		card.pressed.connect(_choose.bind(id, data.cost))
		card.mouse_entered.connect(func():
			var tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tw.tween_property(card, "scale", Vector2(1.06, 1.06),0.15))
		card.mouse_exited.connect(func():
			var tw = create_tween()
			tw.tween_property(card, "scale", Vector2.ONE, 0.1))

func _choose (id:String, cost:float) -> void:
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
