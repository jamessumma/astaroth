extends CharacterBody3D

class_name Enemy

var max_health: int = 100
var cur_health: int = max_health


@onready var navigation_agent = $NavigationAgent3D
@onready var body = $CollisionShape3D
var state_machine: StateMachine


# movement vars
var gravity = 10.0
var base_move_speed = 7
var combat_range: float = 2.0
var vision_range = 10
var distance_to_player = 1000
var cur_direction: Vector3 = Vector3()
var turn_speed: float = 5.0
var path_desired_distance: float = 0.5
var target_desired_distance: float = 0.5
  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_setup()

# inheriting class needs to call enemy_process(delta)
func _physics_process(delta: float) -> void:
	enemy_process(delta)

func enemy_process(delta: float):
	state_machine.update(delta)
	handle_gravity(delta)
	move_and_slide()

# one time setup, needs to be called in ready of inherited class
func enemy_setup():
	self.state_machine = StateMachine.new(self)
	navigation_agent.path_desired_distance = path_desired_distance
	navigation_agent.target_desired_distance = target_desired_distance

func handle_idle():
	update_player_distance()
	if distance_to_player < vision_range:
		self.state_machine.trigger_event(Events.type.DETECT_PLAYER)

func handle_chase():
	update_player_distance()
	if distance_to_player < combat_range:
		self.state_machine.trigger_event(Events.type.IN_COMBAT_RANGE)

# this function serves to choose an attack from a pool based
# on some criteria
func handle_choose_attack():
	pass

func handle_exec_attack():
	pass

func play_chase_anim():
	pass

func handle_flinch():
	pass


func update_player_distance():
	if GameManager.player == null:
		return
	distance_to_player = body.global_position.distance_to(GameManager.player.global_position)

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0


func look_at_slerp(delta):
	var flat_dir = Vector3(cur_direction.x, 0, cur_direction.z).normalized()
	var target_transform = transform.looking_at(global_position - flat_dir, Vector3.UP)
	var target_basis = target_transform.basis
	transform.basis = transform.basis.slerp(target_basis, turn_speed * delta)
	pass

func hit(damage: float):
	# add some code for armor or something here
	print("hit detected")
	print(damage)
	print(cur_health)
	take_damage(damage)

func take_damage(amount: float) -> void:
	cur_health = clamp(cur_health - amount, 0, max_health)
	if cur_health <= 0:
		state_machine.trigger_event(Events.type.DIE)

func handle_move(delta):
	if GameManager.player == null:
		return
	# set the nav to the players position
	navigation_agent.target_position = GameManager.player.global_position
	var pos = navigation_agent.get_next_path_position()
	cur_direction = global_position.direction_to(pos)
	# make the enemy face the direction its moving in
	update_movement_vectors(delta, cur_direction)

func update_movement_vectors(delta: float, dir: Vector3):
	velocity.x = base_move_speed * dir.x
	velocity.z = base_move_speed * dir.z

# below are the functions the inheriting class will want to edit

func enter_idle():
	pass

func enter_chase():
	pass

func enter_choose_attack():
	pass

func enter_exec_attack():
	pass

func enter_flinch():
	pass

func enter_dead():
	# insert death animation here
	queue_free()
	pass