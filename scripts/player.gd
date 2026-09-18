extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"Jump sound"
@onready var death_sound: AudioStreamPlayer2D = $"Death sound"
@onready var goal_reach_sound: AudioStreamPlayer2D = $"Goal reach sound"
@onready var goal_detector: Area2D = $GoalDetector

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
var BOOST_HEIGHT:= -1000

var is_dead := false


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = minf(velocity.y, 1200.0)
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
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		print("vel=", velocity, " floor=", is_on_floor(), " wall=", is_on_wall(), " dead=", is_dead)
	
	_update_animation(direction)
	move_and_slide()
	_check_enemy_collision()
	_check_object_collision()


func _check_enemy_collision() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider.is_in_group("enemies"):
			die()
			return

func _check_object_collision() -> void:
	var overlapping = goal_detector.get_overlapping_areas()
	for area in overlapping:
		if area.is_in_group("endGoal"):
			goal_reach_sound.play()
			var timer := get_tree().current_scene.get_node("Timer")
			LevelManager.time_left = timer.timeLeft
			await LevelManager.go_to_next_level()
			return
		if area.is_in_group("trap"):
			die()
			return
		if area.is_in_group("boost"):
			velocity.y = BOOST_HEIGHT
			return

func die() -> void:
	print("die() called, is_dead=", is_dead)
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	death_sound.play(0.3)
	animated_sprite_2d.play("Hit")
	print("playing: ", animated_sprite_2d.animation, " is_playing=", animated_sprite_2d.is_playing())
	await animated_sprite_2d.animation_finished
	print("animation done")
	LevelManager.restart_level()
	print("restart called")


func _update_animation(direction: float) -> void:
	if not is_on_floor():
		animated_sprite_2d.animation = "Jump"
	elif absf(velocity.x) > 1.0:
		animated_sprite_2d.animation = "Run"
	else:
		animated_sprite_2d.animation = "Idle"

	if direction != 0.0:
		animated_sprite_2d.flip_h = direction < 0.
