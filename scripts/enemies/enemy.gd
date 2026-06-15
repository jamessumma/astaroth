extends CharacterBody3D

class_name Enemy
# all enemies have health, awareness of the player, and attacks
# different variants will override these attributes and methods
var max_health: int = 100
var cur_health: int = max_health

# enemy starts as idle
# if enemy sees player, they chase
# if in range, attack
enum state {IDLE, CHASE, ATTACK, DEAD}
var cur_state: state = state.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	match cur_state:
		state.IDLE:
			handle_idle()
		state.CHASE:
			handle_chase()
		state.ATTACK:
			handle_attack()
		state.DEAD:
			# play death animation, then free from memory
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(amount: float) -> void:
	cur_health = clamp(cur_health - amount, 0, max_health)
	if cur_health <= 0:
		cur_state = state.DEAD
		
func die():
	pass
	
func move():
	pass

func handle_idle():
	pass

func handle_chase():
	pass

func handle_attack():
	pass