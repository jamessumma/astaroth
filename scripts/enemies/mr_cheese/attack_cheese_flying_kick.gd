class_name AttackCheeseFlyingKick

extends Attack

func _init():
  attack_name = "Flying Kick"
  attack_duration = 0.75
  min_range = 2.0
  max_range = 5.0
  base_weight = 10.0
  cur_weight = 1.0
  base_damage = 1.0
  knockback = true
  x_vel_mult = 4.0
  z_vel_mult = 4.0
  speed_mod = 1.2
