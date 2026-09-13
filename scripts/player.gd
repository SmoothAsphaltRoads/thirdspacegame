extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"Jump sound"

const BASE_SPEED := 100.0
const MAX_SPEED := 400.0
const ACCELERATION := 600.0
const FRICTION := 1200.0
const JUMP_VELOCITY := -850.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	var direction := Input.get_axis("left", "right")

	if direction != 0.0:
		if absf(velocity.x) < BASE_SPEED:
			velocity.x = direction * BASE_SPEED
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION  * delta)

	_update_animation(direction)
	move_and_slide()


func _update_animation(direction: float) -> void:
	if not is_on_floor():
		animated_sprite_2d.animation = "Jump"
	elif absf(velocity.x) > 1.0:
		animated_sprite_2d.animation = "Run"
	else:
		animated_sprite_2d.animation = "Idle"

	if direction != 0.0:
		animated_sprite_2d.flip_h = direction < 0.
