extends CanvasLayer
@onready var label: Label = $Label
var timeLimit := 60.0
var timeLeft := 60.0
var running := false
var time_elapse := 0.0
func start(seconds : float) -> void:
	timeLimit = seconds
	timeLeft = seconds
	time_elapse = 0.0
	running = true
	_update_label()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass	
	
func reduce_time (amount:float) -> void:
	timeLeft = max(0.0, timeLeft-amount)
	_update_label()
	if timeLeft<=0.0:
		running = false
		_on_time_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running:
		return
	time_elapse+=delta
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
