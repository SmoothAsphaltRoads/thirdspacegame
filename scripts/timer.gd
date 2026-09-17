extends CanvasLayer
@onready var label: Label = $Label
var timeLimit := 60.0
var timeLeft := 60.0
var running := false

func start(seconds : float) -> void:
	timeLimit = seconds
	timeLeft = seconds
	running = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running:
		return
	
	timeLeft -= delta
	if timeLeft <= 0.0:
		timeLeft = 0.0
		running = false
		_on_time_up()
	
	_update_label()
	
func _update_label() -> void:
	var seconds := int(ceil(timeLeft))
	var minutes := seconds / 60
	var secs := seconds % 60
	label.text = "%d:%02d" % [minutes, secs]

func _on_time_up() -> void:
	LevelManager.restart_level()
