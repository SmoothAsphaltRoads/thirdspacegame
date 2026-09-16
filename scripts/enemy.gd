extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D

var SPEED := 200.0
var ACCELERATION:= 200
var FRICTION:= 600
var target: Node2D = null

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if target:
		var direction := signf(target.global_position.x - global_position.x)
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION*delta)
		_update_animation(direction)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION*delta)
		_update_animation(0.0)
	
	move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body


func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null

func _update_animation(direction: float) -> void:
	if !target:
		animated_sprite_2d.animation = "Idle_2"
	else:
		animated_sprite_2d.animation = "Idle_1"
	
	if direction != 0.0:
		animated_sprite_2d.flip_h = direction > 0.
