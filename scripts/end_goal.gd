extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var i := randi_range(1, 8)
	animated_sprite_2d.animation = str(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		set_deferred("monitoring", false)
		animated_sprite_2d.play("Collected")
		await animated_sprite_2d.animation_finished
		queue_free()
