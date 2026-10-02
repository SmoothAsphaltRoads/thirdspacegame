extends CanvasLayer
@onready var tag: Label = $Panel/VBox/Top/Tag
@onready var level_name: Label = $Panel/VBox/Top/Name
@onready var time: Label = $Panel/VBox/Row/Time
@onready var bar: ProgressBar = $Panel/VBox/Bar

var timeLimit := 60.0
var timeLeft := 60.0
var running := false
var time_elapse := 0.0

func start(seconds : float) -> void:
	tag.text = LevelManager.level_tag() if LevelManager.has_method("level_tag") else "idk"
	level_name.text = LevelManager.level_data().name if LevelManager.has_method("level_data") else ""
	timeLimit = seconds
	timeLeft = seconds
	time_elapse = 0.0
	bar.max_value = seconds
	bar.value = running
	running = true
	_update_label()
	if timeLeft <=0.0:
		_on_time_up()
	
func _process (delta : float) -> void:
	if not running:
		return
	time_elapse += delta
	timeLeft -= delta
	bar.value = timeLeft
	if timeLeft <=0.0:
		_on_time_up()
	_update_label()
	
func _update_label() -> void:
	var s:= int(ceil(timeLeft))
	time.text = "%d%02d" % [s/60, s%60]
	time.modulate = Color("ff8e80") if (timeLeft <= 5.0 and running) else Color.WHITE

func _on_time_up() -> void:
	timeLeft = 0.0
	running = false
	LevelManager.restart_level()
	
func reduce_time(amount : float) -> void:
	timeLeft = maxf(0.0, timeLeft-amount)
	_update_label()
	if timeLeft<=0.0:
		_update_label()
