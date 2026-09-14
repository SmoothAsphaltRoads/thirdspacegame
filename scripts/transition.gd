extends Node
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cover() -> void:
	anim_player.play("cover")
	await anim_player.animation_finished

func reveal() -> void:
	anim_player.play("reveal")
	await anim_player.animation_finished
