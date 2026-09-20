extends StaticBody2D
@onready var hit_detector: Area2D = $HitDetector
@onready var sprite_2d: Sprite2D = $Sprite2D
var is_hit: bool = false
@onready var label: Label = $CanvasLayer/Label
@export var info_text: String = "Press Jump to Leap!"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
func _ready() -> void:
	label.visible=false

func _on_hit_detector_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if is_hit:
		return
	is_hit = true
	sprite_2d.visible = false
	label.visible = true
	audio_stream_player_2d.play(0.0)

func _input(event:InputEvent) ->void :
	if Input.is_action_just_pressed("ui_cancel"):
		sprite_2d.visible = true
		is_hit = false
		label.visible = false


func _on_button_pressed() -> void:
	sprite_2d.visible = true
	is_hit = false
	label.visible = false
