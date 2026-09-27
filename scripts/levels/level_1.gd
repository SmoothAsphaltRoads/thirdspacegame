extends Node
@onready var timer: CanvasLayer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(10.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
