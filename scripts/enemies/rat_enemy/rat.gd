extends Enemy

class_name Rat
var attack_timer_max: float = 2
var attack_timer_cur: float = 0

@onready var animation_player = $RatModel/AnimationPlayer

func _ready() -> void:
	print("rat ready called")
	max_health = 1
	cur_health = max_health
	$BodyHitbox.body_part_hit.connect(hit)
	$HeadHitbox.body_part_hit.connect(hit)
	enemy_setup()

	self.attacks = [AttackRatBite.new(), AttackRatJump.new()]

	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	attack_timer_cur = clamp(attack_timer_cur - delta, 0, attack_timer_max)
	enemy_process(delta)

func enter_idle():
	animation_player.play("Armature|Rat_Idle")

func enter_chase():
	animation_player.play("Armature|Rat_Run")
		
func handle_attack():
	#var flat_dir = Vector3(cur_direction.x, 0, cur_direction.z).normalized()
	#look_at_slerp(delta)
	pass

func enter_exec_attack():
	animation_player.play(self.next_attack.attack_name)
	attack_timer_cur = attack_timer_max
	
func enter_dead():
	animation_player.play("Armature|Rat_Death")

func enter_reposition():
	print("enter reposition")
	animation_player.play("Armature|Rat_Run")

func _on_animation_finished(anim_name):
	if anim_name == "Armature|Rat_Death":
		queue_free()
	if anim_name == next_attack.attack_name:
		self.state_machine.trigger_event(Events.type.ATTACK_FINISHED)
