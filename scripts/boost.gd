extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node2D) -> void:
	if body.is_in_group("player"):
		animated_sprite_2d.animation = "Hit"
		await animated_sprite_2d.animation_finished
		queue_free()
