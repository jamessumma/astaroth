extends Node

class_name Enemy

@export var max_health: int = 100
var current_health: int

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
	
