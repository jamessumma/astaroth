extends Enemy

class_name MrCheese

var attack_timer_max: float = 2
var attack_timer_cur: float = 0

@onready var animation_player: AnimationPlayer = $MrCheeseModel/AnimationPlayer
	
func _ready() -> void:
	self.combat_range = 10.0
	max_health = 1
	cur_health = max_health
	enemy_setup()

	self.attacks = [AttackCheesePunch.new(), AttackCheeseThrow.new(), AttackCheeseFlyingKick.new(), AttackCheeseJump.new()]
	animation_player.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	attack_timer_cur = clamp(attack_timer_cur - delta, 0, attack_timer_max)

	var rm := animation_player.get_root_motion_position()
	if animation_player.current_animation == "mutant run":
		rm = Vector3.ZERO
	else:
		velocity = (global_transform.basis * rm) / delta

	enemy_process(delta)


func enter_idle():
	animation_player.play("mutant breathing idle", 0.6)


func enter_chase():
	animation_player.play("mutant run", 0.6)
	

func enter_exec_attack():
	print(self.next_attack.attack_name)
	animation_player.play(self.next_attack.attack_name, 0.6, self.next_attack.speed_mod)
	print("post attack")
	attack_timer_cur = attack_timer_max

func enter_dead():
	animation_player.play("mutant dying", 0.6)

func enter_reposition():
	print("enter reposition")
	animation_player.play("mutant run", 0.6)

func _on_animation_finished(anim_name):
	if anim_name == "mutant dying":
		queue_free()
	if next_attack:
		if anim_name == next_attack.attack_name:
			self.state_machine.trigger_event(Events.type.ATTACK_FINISHED)
