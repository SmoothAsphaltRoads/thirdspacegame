extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"Jump sound"
@onready var death_sound: AudioStreamPlayer2D = $"Death sound"
@onready var goal_reach_sound: AudioStreamPlayer2D = $"Goal reach sound"
@onready var goal_detector: Area2D = $GoalDetector
@onready var dust_particles: CPUParticles2D = $DustParticles
@onready var shield_indi: Label = $ShieldIndi

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
var SPEED_MULTIPLIER := 1.0
var JUMP_MULTIPLIER := 1.0
var has_shield := false
var shield_active := false
var speed_multiplier: float:
	get:
		return SPEED_MULTIPLIER
	set(value):
		SPEED_MULTIPLIER = value
var jump_multiplier: float:
	get:
		return JUMP_MULTIPLIER
	set(value):
		JUMP_MULTIPLIER = value
var is_invincible := false
var is_dead := false
var was_on_floor = true

func grant_shield() -> void:
	has_shield =true
	shield_indi.text = "[E] SHIELD"
	shield_indi.visible = true

func _physics_process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_E) and has_shield and not shield_active):
		use_shield()
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

	if JUMP_BUFFER_TIMER > 0.0:
		if COYOTE_TIMER > 0.0:
			velocity.y = JUMP_HEIGHT * JUMP_MULTIPLIER
			COYOTE_TIMER = 0.0
			JUMP_BUFFER_TIMER = 0.0
			jump_sound.play()
			animated_sprite_2d.scale = Vector2(0.75, 1.3)
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = max(velocity.y * CUT_MULTIPLIER, MIN_JUMP_HEIGHT)

	var direction := Input.get_axis("left", "right")

	if direction != 0.0:
		if absf(velocity.x) < BASE_SPEED:
			velocity.x = direction * BASE_SPEED
		velocity.x = move_toward(velocity.x, direction * (MAX_SPEED*SPEED_MULTIPLIER), ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)
	
	_update_animation(direction)
	move_and_slide()
	if not was_on_floor and is_on_floor():
		animated_sprite_2d.scale = Vector2(1.3, 0.7)
	was_on_floor = is_on_floor()
	animated_sprite_2d.scale = animated_sprite_2d.scale.lerp(Vector2.ONE, 12.0*delta)
	_check_enemy_collision()
	_check_object_collision()
	
func use_shield() -> void:
	if not has_shield or shield_active or is_dead:
		return
	has_shield = false
	shield_active = true
	is_invincible = true
	modulate = Color(0.3, 0.8, 1.0, 0.8)
	
	var time_left := 1.0
	while time_left > 0 and is_invincible and not is_dead:
		shield_indi.text = "%.1fs" % time_left
		await get_tree().create_timer(0.1).timeout
		time_left -=0.1
	
	is_invincible=false
	shield_active=false
	modulate = Color(1.0,1.0,1.0,1.0)
	shield_indi.visible = false

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
			LevelManager.time_taken = timer.time_elapse
			await LevelManager.go_to_next_level()
			return
		if area.is_in_group("trap"):
			die()
			return
		if area.is_in_group("boost"):
			velocity.y = BOOST_HEIGHT
			return

func die() -> void:
	if is_invincible:
		return
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	death_sound.play(0.3)

	if (LevelManager.current_level <= 5):
		animated_sprite_2d.play("hit1")
	else:
		animated_sprite_2d.play("hit2")
	
	await animated_sprite_2d.animation_finished
	LevelManager.restart_level()


func _update_animation(direction: float) -> void:
	if not is_on_floor():
		
		if (LevelManager.current_level <= 5):
			animated_sprite_2d.animation = "jump1"
		else:
			animated_sprite_2d.animation = "jump2"
			
		dust_particles.emitting = false
	elif absf(velocity.x) > 1.0:
		if (LevelManager.current_level <= 5):
			animated_sprite_2d.animation = "run1"
		else:
			animated_sprite_2d.animation = "run2"
		dust_particles.emitting = true
	else:
		if (LevelManager.current_level <= 5):
			animated_sprite_2d.animation = "idle1"
		else:
			animated_sprite_2d.animation = "idle2"
		dust_particles.emitting = false
	if direction != 0.0:
		animated_sprite_2d.flip_h = direction < 0.0
		dust_particles.scale.x = -1.0 if direction <0.0 else 1.0
		
func _ready() -> void:
	pass
