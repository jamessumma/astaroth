extends CharacterBody3D

class_name Enemy

var max_health: int = 100
var cur_health: int = max_health


@onready var navigation_agent = $NavigationAgent3D
@onready var body = $WorldColliderShape
var state_machine: StateMachine

var using_root_motion: bool = false

# movement vars
var gravity = 10.0
var base_move_speed = 7
var combat_range: float = 2.0
var vision_range = 10
var distance_to_player = 1000
var turn_speed: float = 5.0
var path_desired_distance: float = 0.5
var target_desired_distance: float = 0.5
var attacks: Array[Attack] = []
var next_attack: Attack = null
var attack_timer: float = 0.0

var last_hit_part: BodyPart = null

# enemy behavior
var grounded_enemy = true

var lerp_weight: float = 5.0
var cur_facing_direction_vector: Vector3 = Vector3(0,0,0)
var cur_direction_vector_pull: Vector3 = Vector3(0,0,0)
# degrees of tolerance to determine whether enemy is facing player or not
var facing_player_angle: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_setup()

# inheriting class needs to call enemy_process(delta)
func _physics_process(delta: float) -> void:
	enemy_process(delta)

func enemy_process(delta: float):
	state_machine.update(delta)
	handle_gravity(delta)
	move_process(delta)
	move_and_slide()

# one time setup, needs to be called in ready of inherited class
func enemy_setup():
	print("enemy setup called")
	self.state_machine = StateMachine.new(self)
	self.cur_facing_direction_vector = Vector3(0.0, 0.0, 0.0)
	self.cur_direction_vector_pull = Vector3(0.0, 0.0, 0.0)
	navigation_agent.path_desired_distance = path_desired_distance
	navigation_agent.target_desired_distance = target_desired_distance
	for part in find_children("*", "Area3D", true):
		if part.is_in_group("StandardHitBox"):
			part.body_part_hit.connect(_on_standard_hit)
		elif part.is_in_group("CriticalHitBox"):
			part.body_part_hit.connect(_on_critical_hit)

func handle_idle():
	update_player_distance()
	if distance_to_player < vision_range:
		if self.grounded_enemy && is_on_floor():
			self.state_machine.trigger_event(Events.type.DETECT_PLAYER)
		if !self.grounded_enemy:
			self.state_machine.trigger_event(Events.type.DETECT_PLAYER)

func handle_chase():
	update_player_distance()
	if distance_to_player < combat_range:
		self.state_machine.trigger_event(Events.type.IN_COMBAT_RANGE)

# this function serves to choose an attack from a pool based
# on some criteria
func handle_choose_attack():
	self.next_attack = self.choose_attack()
	if self.next_attack:
		print(self.next_attack.attack_name)
	state_machine.trigger_event(Events.type.ATTACK_CHOSEN)

func handle_exec_attack():
	pass

func play_chase_anim():
	pass

func handle_flinch():
	pass

func handle_reposition():
	update_player_distance()
	if attack_in_range(self.next_attack):
		if aligned_to_player():
			state_machine.trigger_event(Events.type.IN_ATTACK_RANGE)
		else:
			set_facing_to_player()


func update_player_distance():
	if GameManager.player == null:
		return
	distance_to_player = body.global_position.distance_to(GameManager.player.global_position)

func handle_gravity(delta):
	if using_root_motion:
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0


func look_at_slerp(delta):
	var flat_dir = Vector3(cur_facing_direction_vector.x, 0, cur_facing_direction_vector.z).normalized()
	if flat_dir.length_squared() < 0.0001:
		return
	var target_transform = transform.looking_at(global_position - flat_dir, Vector3.UP)
	var target_basis = target_transform.basis
	transform.basis = transform.basis.slerp(target_basis, turn_speed * delta)

func _on_standard_hit(dam: float, part: BodyPart) -> void:
	self.last_hit_part = part
	take_damage(dam)
	
func _on_critical_hit(dam: float, part: BodyPart) -> void:
	self.last_hit_part = part
	take_damage(dam * 1.5)

func take_damage(amount: float) -> void:
	cur_health = clamp(cur_health - amount, 0, max_health)
	if cur_health <= 0:
		state_machine.trigger_event(Events.type.DIE)

# update velocity vector to the path to the player
func set_pull_to_player():
	if GameManager.player == null:
		return
	# set the nav to the players position
	navigation_agent.target_position = GameManager.player.global_position
	var pos = navigation_agent.get_next_path_position()
	self.cur_direction_vector_pull = global_position.direction_to(pos)
	# make the enemy face the direction its moving in

func set_pull_vector_stop():
	self.cur_direction_vector_pull.x = 0.0
	self.cur_direction_vector_pull.y = velocity.y
	self.cur_direction_vector_pull.z = 0.0


# move process gets called every call to physics proces
func move_process(delta):
	if using_root_motion:
		return
	# every physics process, update the movement vector to pull towards the pull vector
	# so the idea is, by default, pull towards zero
	# then, certain states will call functions that will modify the pull vector
	# for instance, chase will set the pull to the player on the nav graph
	update_movement_vectors(self.cur_direction_vector_pull, delta)

func update_movement_vectors(dir: Vector3, delta: float):
	var cur = Vector3(velocity.x, velocity.y, velocity.z)

	var x_tmp = base_move_speed * dir.x
	var z_tmp = base_move_speed * dir.z

	velocity.x = lerp(cur.x, x_tmp, lerp_weight * delta)
	velocity.z = lerp(cur.z, z_tmp, lerp_weight * delta)

	# update facing direction
	cur_facing_direction_vector.x = velocity.x
	cur_facing_direction_vector.z = velocity.z

func set_facing_to_player():
	if GameManager.player == null:
		return
	# set the direction to the players position
	self.cur_facing_direction_vector = global_position.direction_to(GameManager.player.global_position)

func aligned_to_player() -> bool:
	if GameManager.player == null:
		return false
	var to_player = global_position.direction_to(GameManager.player.global_position)
	var forward = global_transform.basis.z
	to_player.y = 0
	forward.y = 0
	return to_player.angle_to(forward) <= deg_to_rad(self.facing_player_angle)


func choose_attack() -> Attack:
	var cur_attack = null
	var cur_attack_weight = -INF

	for attack in self.attacks:
		var cur = attack_value(attack)
		if cur > cur_attack_weight:
			cur_attack = attack
			cur_attack_weight = cur

	adjust_weights(cur_attack)
	return cur_attack

# function shifts the weights after an attack is selected 
func adjust_weights(chosen_attack: Attack):
	if not chosen_attack:
		return
	for attack in self.attacks:
		attack.cur_weight += self.attacks.size()
	chosen_attack.cur_weight = chosen_attack.base_weight


func attack_value(attack: Attack) -> float:
	var res = attack.cur_weight
	if attack_in_range(attack):
		res += self.attacks.size()
	return res

func attack_in_range(attack: Attack) -> bool:
	return ((attack.min_range <= self.distance_to_player) and (attack.max_range >= self.distance_to_player))

func update_state_attack(_delta: float):
	velocity.x *= self.next_attack.x_vel_mult
	velocity.z *= self.next_attack.z_vel_mult
	velocity.y *= self.next_attack.y_vel_mult
# below are the functions the inheriting class will want to edit

func enter_idle():
	pass

func enter_chase():
	pass

func enter_choose_attack():
	pass

func enter_reposition():
	pass

func enter_exec_attack():
	pass

func enter_flinch():
	pass

func enter_dead():
	# insert death animation here
	queue_free()
	pass

func exit_move_state():
	pass
