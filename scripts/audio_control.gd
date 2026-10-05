extends HSlider

@export var audio_bus_name: String

var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	if audio_bus_id >= 0:
		value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
