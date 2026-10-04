extends CanvasLayer

const INFO := {
	"speed" : ["speed boost", "always on", preload("res://assets/ui/icon-speed.png")],
	"jump" : ["jump boost", "always on", preload("res://assets/ui/icon-jump.png")],
	"glide" : ["fether fall", "hold jump", preload("res://assets/ui/icon-feather.png")],
	"double_jump" : ["double jump", "jump twice midair", preload("res://assets/ui/icon-doublejump.png")],
	"dash" : ["dash", "press shift", preload("res://assets/ui/icon-dash.png")],
	"shield" : ["shield", "press [E]", preload("res://assets/ui/icon-shield.png")]
}

@onready var panel: PanelContainer = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("boost_indicator")
	panel.visible = false

func show_boost(id: String) -> void:
	if not INFO.has(id):
		return
	$Panel/HBox/Icon.texture = INFO[id][2]
	$Panel/HBox/Text/Name.text = INFO[id][0]
	$Panel/HBox/Text/Hint.text = INFO[id][1]
	panel.visible = true
	panel.modulate.a = 0.0
	create_tween().tween_property(panel, "modulate:a", 1.0, 0.2)

func _process(delta: float) -> void:
	
	pass
