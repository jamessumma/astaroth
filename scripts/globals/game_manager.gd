extends Node

# singleton player
var player = null

# settings
var sfx_volume: float = 100.0
var music_volume: float = 100.0
var master_volume: float = 100.0

func _ready():
	apply_settings()

func set_sfx_volume(value: float):
	sfx_volume = clamp(value, 0.0, 100.0)
	apply_settings()
	
func set_music_volume(value: float):
	music_volume = clamp(value, 0.0, 100.0)
	apply_settings()
	
func set_master_volume(value: float):
	master_volume = clamp(value, 0.0, 100.0)
	apply_settings()
	
func apply_settings():
	var sfx_bus = AudioServer.get_bus_index("SFX")
	var music_bus = AudioServer.get_bus_index("Music")
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume / 100.0))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume / 100.0))
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_volume / 100.0))
