
class_name Shotgun

# shots per second
var fire_rate: float = 1.0
# cone of spread in degrees
var spread: float = 15.0
# number of bullets spawned per shot
var num_shots: int = 3

# bullet tscn
const BULLET_OBJ = preload("res://scenes/weapons/bullet.tscn")

