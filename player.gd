extends CharacterBody2D

@export var speed: float = 300.0
## Extra top speed unlocked by holding one direction.
@export var sprint_speed: float = 460.0
## Seconds of holding a direction before sprint kicks in.
@export var sprint_delay: float = 0.6

## Pixels per second, per second. Higher = snappier starts.
@export var acceleration: float = 2000.0
## How hard you stop when you let go.
@export var friction: float = 2500.0
## Air control is weaker than ground control.
@export var air_acceleration: float = 900.0

@export var jump_velocity: float = -420.0
## Grace period after walking off a ledge where a jump still counts.
@export var coyote_time: float = 0.1
## Grace period before landing where a jump press is remembered.
@export var jump_buffer_time: float = 0.1

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _run_time: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		velocity += get_gravity() * delta
		_coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	else:
		_jump_buffer_timer -= delta

	if _jump_buffer_timer > 0.0 and _coyote_timer > 0.0:
		velocity.y = jump_velocity
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0

	# Released the button early: cut the rise short for a shorter hop.
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.5

	var direction := Input.get_axis("move_left", "move_right")

	# Seconds spent holding one direction. Resets on release or turnaround.
	if direction != 0.0:
		_run_time += delta
	else:
		_run_time = 0.0

	var top_speed := sprint_speed if _run_time > sprint_delay else speed
	var accel := acceleration if is_on_floor() else air_acceleration

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * top_speed, accel * delta)
		_sprite.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	move_and_slide()
