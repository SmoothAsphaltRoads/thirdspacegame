extends CanvasLayer
@onready var tag: Label = $Panel/VBox/Tag
@onready var value: Label = $Panel/VBox/Card/VBoxContainer/Time/Value
@onready var bestlabel : Label = $Panel/VBox/Card/VBoxContainer/Best
@onready var stars = [$Panel/VBox/Stars/s1/Icon, $Panel/VBox/Stars/s2/Icon2,$Panel/VBox/Stars/s3/Icon3]
@onready var deathvalue: Label = $Panel/VBox/Card/VBoxContainer/Death/Value

func _ready() -> void:
	for b in $Panel/VBox/Buttons.get_children():
		b.mouse_entered.connect(b.grab_focus)
	await get_tree().process_frame
	$Panel/VBox/Buttons/Next.grab_focus()

func setup (idx: int, t:float) -> void:
	tag.text = "Level %d" % (idx+1)
	value.text = "%.2fs" % t
	deathvalue.text = str(LevelManager.level_deaths)
	
	var best = LevelManager.best_times.get(idx, INF) if "best_times" in LevelManager else INF
	if (t<best) and "best_times" in LevelManager:
		LevelManager.best_times[idx] = t
		bestlabel.text = "new best!"
		bestlabel.modulate = Color("ffd166")
	else:
		bestlabel.text = "best %.2fs" % best
	get_tree().paused = true
	for i in LevelManager.stars_calc(t):
		await get_tree().create_timer(0.2, true, false, true).timeout
		stars[i].modulate = Color.WHITE
		var tw = create_tween()
		tw.tween_property(stars[i], "scale", Vector2(1.4,1.4), 0.1)
		tw.tween_property(stars[i], "scale", Vector2.ONE, 0.1)
func _on_next_pressed() -> void:
	get_tree().paused = false
	queue_free()
	LevelManager.go_to_next_level()


func _on_retry_pressed() -> void:
	get_tree().paused = false
	queue_free()
	LevelManager.restart_level()


func _on_levels_pressed() -> void:
	get_tree().paused = false
	queue_free()
	LevelManager.change_scene("res://scenes/startscreen.tscn")
