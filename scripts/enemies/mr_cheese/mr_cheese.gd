extends Enemy

class_name MrCheese

var attack_timer_max: float = 2
var attack_timer_cur: float = 0

@onready var animation_player: AnimationPlayer = $MrCheese/AnimationPlayer

func _ready() -> void:
	base_move_speed = 4
	max_health = 1
	cur_health = max_health
	
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	attack_timer_cur = clamp(attack_timer_cur - delta, 0, attack_timer_max)
	enemy_process(delta)

func handle_idle(delta: float):
	if !animation_player.is_playing():
		animation_player.play("Punching Bag/mixamo_com", 0.3)

func handle_chase(delta: float):
	if !animation_player.current_animation == "Mutant Run-2/mixamo_com":
		animation_player.play("Mutant Run-2/mixamo_com", 0.3)

		
func handle_attack(delta: float):
	#var flat_dir = Vector3(cur_direction.x, 0, cur_direction.z).normalized()
	look_at_slerp(delta)
	if !animation_player.is_playing() and attack_timer_cur <= 0:
		animation_player.play("Standing Melee Attack Downward/mixamo_com", 0.3)
		attack_timer_cur = attack_timer_max
	
func die():
	animation_player.play("Dying/mixamo_com", 0.3)

func _on_animation_finished(anim_name):
	if anim_name == "Dying/mixamo_com":
		queue_free()
