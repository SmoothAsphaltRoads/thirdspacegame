extends Label

@onready var _player: CharacterBody2D = get_node("../../Player")


func _process(_delta: float) -> void:
	# _process runs once per RENDERED frame, so FPS updates smoothly here.
	text = "fps            %d\n" % Engine.get_frames_per_second()
	text += "physics ticks  %d\n" % Engine.get_physics_frames()
	text += "rendered frame %d\n" % Engine.get_process_frames()
	text += "\n"
	text += "velocity.x     %6.1f\n" % _player.velocity.x
	text += "velocity.y     %6.1f\n" % _player.velocity.y
	text += "on floor       %s\n" % _player.is_on_floor()
