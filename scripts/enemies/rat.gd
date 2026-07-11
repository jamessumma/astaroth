extends Enemy

class_name Rat
var attack_timer_max: float = 2
var attack_timer_cur: float = 0

@onready var animation_player = $RatModel/AnimationPlayer

func _ready() -> void:
	max_health = 1
	cur_health = max_health
	$BodyHitbox.body_part_hit.connect(hit)
	$HeadHitbox.body_part_hit.connect(hit)
	enemy_setup()

	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	attack_timer_cur = clamp(attack_timer_cur - delta, 0, attack_timer_max)
	enemy_process(delta)

func enter_idle():
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Idle")

func enter_chase(delta: float):
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Run")
		
func handle_attack(delta: float):
	#var flat_dir = Vector3(cur_direction.x, 0, cur_direction.z).normalized()
	look_at_slerp(delta)
	if !animation_player.is_playing() and attack_timer_cur <= 0:
		animation_player.play("Armature|Rat_Attack")
		attack_timer_cur = attack_timer_max
	
func enter_dead():
	animation_player.play("Armature|Rat_Death")

func _on_animation_finished(anim_name):
	if anim_name == "Armature|Rat_Death":
		queue_free()
