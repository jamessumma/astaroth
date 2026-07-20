extends Enemy

class_name MrCheese

var attack_timer_max: float = 2
var attack_timer_cur: float = 0

@onready var animation_player: AnimationPlayer = $MrCheese/AnimationPlayer

func _ready() -> void:
	max_health = 1
	cur_health = max_health
	enemy_setup()

	self.attacks = [AttackCheesePunch.new(), AttackCheeseThrow.new(), AttackCheeseFlyingKick.new(), AttackCheeseJump.new()]

	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	attack_timer_cur = clamp(attack_timer_cur - delta, 0, attack_timer_max)
	enemy_process(delta)


func enter_idle():
	animation_player.play("Punching Bag/mixamo_com", 0.3)


func enter_chase():
	animation_player.play("Mutant Run-2/mixamo_com", 0.3)

		
func handle_attack(delta: float):
	#var flat_dir = Vector3(cur_direction.x, 0, cur_direction.z).normalized()
	#look_at_slerp(delta)
	#if !animation_player.is_playing() and attack_timer_cur <= 0:
	#	animation_player.play("Standing Melee Attack Downward/mixamo_com", 0.3)
	#	attack_timer_cur = attack_timer_max
	pass
	

func enter_exec_attack():
	print(self.next_attack.attack_name)
	animation_player.play(self.next_attack.attack_name, 0.3)
	print("post attack")
	attack_timer_cur = attack_timer_max

func enter_dead():
	animation_player.play("Dying/mixamo_com", 0.3)

func enter_reposition():
	print("enter reposition")
	animation_player.play("Mutant Run-2/mixamo_com")

func _on_animation_finished(anim_name):
	if anim_name == "Dying/mixamo_com":
		queue_free()
	if next_attack:
		if anim_name == next_attack.attack_name:
			self.state_machine.trigger_event(Events.type.ATTACK_FINISHED)
