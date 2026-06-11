extends Node

class_name Enemy
# all enemies have health, awareness of the player, and attacks
# different variants will override these attributes and methods
@export var max_health: int = 100
var current_health: int

var aware_of_player = false
var line_of_sight_player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: float) -> void:
	current_health -= damage
	print(current_health)
	if current_health <= 0:
		die()
		
func die():
	queue_free()
	
