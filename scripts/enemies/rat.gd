extends Enemy

class_name Rat
var attack_timer_max: float = 2
var attack_timer_cur: float = 0

@onready var animation_player = $RatModel/AnimationPlayer

func _ready() -> void:
	enemy_setup()

func _physics_process(delta: float) -> void:
	attack_timer_cur = clamp(attack_timer_cur - delta, 0, attack_timer_max)
	enemy_process(delta)

func handle_idle(delta: float):
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Idle")

func handle_chase(delta: float):
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Run")
		
func handle_attack(delta: float):
	#var flat_dir = Vector3(cur_direction.x, 0, cur_direction.z).normalized()
	look_at_slerp(delta)
	if !animation_player.is_playing() and attack_timer_cur <= 0:
		animation_player.play("Armature|Rat_Attack")
		attack_timer_cur = attack_timer_max
	
func die():
	if !animation_player.is_playing() and attack_timer_cur <= 0:
		animation_player.play("Armature|Rat_Death")