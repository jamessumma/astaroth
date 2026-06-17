extends CharacterBody3D

class_name Enemy
# all enemies have health, awareness of the player, and attacks
# different variants will override these attributes and methods
var max_health: int = 100
var cur_health: int = max_health
var turn_speed: float = 5.0

@onready var navigation_agent = $NavigationAgent3D
@onready var body = $CollisionShape3D

# movement vars
var gravity = 10.0
var base_move_speed = 7
var attack_range = 2
var vision_range = 10
var distance_to_player = 1000
var cur_direction: Vector3 = Vector3()

# enemy starts as idle
# if enemy sees player, they chase
# if in range, attack
enum state {IDLE, CHASE, ATTACK, DEAD}
var cur_state: state = state.IDLE
var path_desired_distance: float = 0.5
var target_desired_distance: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_setup()

# inheriting class needs to call enemy_process(delta)
func _physics_process(delta: float) -> void:
	enemy_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enemy_process(delta: float):
	handle_state(delta)
	handle_gravity(delta)
	move_and_slide()

# one time setup, needs to be called in ready of inherited class
func enemy_setup():
	navigation_agent.path_desired_distance = path_desired_distance
	navigation_agent.target_desired_distance = target_desired_distance

func take_damage(amount: float) -> void:
	cur_health = clamp(cur_health - amount, 0, max_health)
	if cur_health <= 0:
		cur_state = state.DEAD
		
func handle_state(delta:float):
	match cur_state:
		state.IDLE:
			handle_idle(delta)
		state.CHASE:
			handle_chase(delta)
			handle_chase_movement(delta)
		state.ATTACK:
			handle_attack(delta)
		state.DEAD:
			# play death animation, then free from memory
			die()
			queue_free()
	check_state()
	
# checks the conditions for each state and changes accordingly
func check_state():
	update_player_distance()
	match cur_state:
		state.IDLE:
			if distance_to_player < vision_range:
				cur_state = state.CHASE
				print("Going to chase")
		state.CHASE:
			if distance_to_player < attack_range:
				cur_state = state.ATTACK
				print("Going to attack")
		state.ATTACK:
			if distance_to_player > attack_range:
				cur_state = state.CHASE
		_:
			pass

func update_player_distance():
	if GameManager.player == null:
		return
	distance_to_player = body.global_position.distance_to(GameManager.player.global_position)

# override this function to call the death animation
func die():
	pass

func handle_idle(delta: float):
	pass

func handle_chase(delta: float):
	pass

func handle_chase_movement(delta):
	if GameManager.player == null:
		print("player is null")
		return
	# set the nav to the players position
	navigation_agent.target_position = GameManager.player.global_position
	var pos = navigation_agent.get_next_path_position()
	cur_direction = global_position.direction_to(pos)
	# make the enemy face the direction its moving in
	look_at_slerp(delta)
	handle_move(delta, cur_direction)

func handle_attack(delta: float):
	pass

func handle_move(delta: float, dir: Vector3):
	velocity.x = base_move_speed * dir.x
	velocity.z = base_move_speed * dir.z

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
	take_damage(damage)
