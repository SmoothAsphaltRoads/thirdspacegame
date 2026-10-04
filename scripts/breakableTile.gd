extends StaticBody2D

@export var break_delay := 0.5
@export var respawn_time := 2.0
@export var shake_px := 2
@export var cracked_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var detector: Area2D = $Detector

var breaking := false
var base_pos: Vector2
var normal_texture: Texture2D

func _ready() -> void:
	base_pos = sprite.position
	normal_texture = sprite.texture
	detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if breaking or not body.is_in_group("player"):
		return
	_break()

func _break() -> void:
	breaking = true
	if cracked_texture:
		sprite.texture = cracked_texture

	var t := create_tween()
	for i in 6:
		var offset := Vector2(randi_range(-shake_px, shake_px), 0)
		t.tween_property(sprite, "position", base_pos + offset, break_delay / 6.0)
	await t.finished
	sprite.position = base_pos

	shape.set_deferred("disabled", true)
	create_tween().tween_property(sprite, "modulate:a", 0.0, 0.15)

	await get_tree().create_timer(respawn_time).timeout
	while _player_on_top():
		await get_tree().physics_frame

	sprite.texture = normal_texture
	shape.set_deferred("disabled", false)
	create_tween().tween_property(sprite, "modulate:a", 1.0, 0.2)
	breaking = false

func _player_on_top() -> bool:
	for body in detector.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false
