extends Node2D

@export var always_on := false
@export var on_time := 1.5
@export var off_time := 1.5
@export var delay := 0.0

@onready var emitter: Sprite2D = $Emitter
@onready var ray: RayCast2D = $RayCast2D
@onready var beam: Line2D = $Beam
@onready var shape: CollisionShape2D = $Hitbox/CollisionShape2D

var _t := 0.0

func _ready() -> void:
	shape.shape = shape.shape.duplicate()
	_update_beam()

func _physics_process(delta: float) -> void:
	_t += delta
	_update_beam()
	_update_state()

func _update_beam() -> void:
	ray.force_raycast_update()
	var length := 2000.0
	if ray.is_colliding():
		length = to_local(ray.get_collision_point()).length()
	beam.points = PackedVector2Array([Vector2(21, 0), Vector2(length, 0)])
	var rect: RectangleShape2D = shape.shape
	rect.size = Vector2(maxf(length - 21, 1.0), 12.0)
	shape.position = Vector2((21 + length) / 2.0, 0)

func _update_state() -> void:
	var is_firing := true
	if not always_on:
		var period := on_time + off_time
		var phase := fposmod(_t + delay, period)
		is_firing = phase < on_time

	beam.visible = is_firing
	emitter.frame = 2 if is_firing else 0
	shape.set_deferred("disabled", not is_firing)
