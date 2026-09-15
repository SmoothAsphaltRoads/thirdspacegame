extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"Jump sound"
@onready var death_sound: AudioStreamPlayer2D = $"Death sound"

const BASE_SPEED := 50.0
const MAX_SPEED := 300.0
const ACCELERATION := 600.0
const FRICTION := 1400.0
const JUMP_HEIGHT := -850.0
const CUT_MULTIPLIER := 1.0
const MIN_JUMP_HEIGHT := -300.0
const COYOTE_TIME := 0.15
var COYOTE_TIMER := 0.0
const JUMP_BUFFER_TIME := 0.15
var JUMP_BUFFER_TIMER := 0.0

var is_dead := false


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
		COYOTE_TIMER -= delta
	else:
		COYOTE_TIMER = COYOTE_TIME

	if Input.is_action_just_pressed("jump"):
		JUMP_BUFFER_TIMER = JUMP_BUFFER_TIME
	else:
		JUMP_BUFFER_TIMER -= delta

	if Input.is_action_just_pressed("restart"):
		LevelManager.restart_level()
	if Input.is_action_just_pressed("next"):
		LevelManager.go_to_next_level()

	if JUMP_BUFFER_TIMER > 0.0 and COYOTE_TIMER > 0.0:
		velocity.y = JUMP_HEIGHT
		COYOTE_TIMER = 0.0
		JUMP_BUFFER_TIMER = 0.0
		jump_sound.play()

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = max(velocity.y * CUT_MULTIPLIER, MIN_JUMP_HEIGHT)

	var direction := Input.get_axis("left", "right")

	if direction != 0.0:
		if absf(velocity.x) < BASE_SPEED:
			velocity.x = direction * BASE_SPEED
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	_update_animation(direction)
	move_and_slide()
	_check_enemy_collision()


func _check_enemy_collision() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.is_in_group("enemies"):
			die()
			return

func die() -> void:
	death_sound.play(0.3)
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.animation = "Hit"
	await animated_sprite_2d.animation_finished
	LevelManager.restart_level()
	is_dead = false 


func _update_animation(direction: float) -> void:
	if not is_on_floor():
		animated_sprite_2d.animation = "Jump"
	elif absf(velocity.x) > 1.0:
		animated_sprite_2d.animation = "Run"
	else:
		animated_sprite_2d.animation = "Idle"

	if direction != 0.0:
		animated_sprite_2d.flip_h = direction < 0.
