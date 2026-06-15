extends Enemy

class_name Rat

@onready var animation_player = $RatModel/AnimationPlayer
@onready var navigation_agent = $NavigationAgent3D
@onready var body = $CollisionShape3D


var gravity = 10.0
var base_move_speed = 7
var attack_range = 5
var vision_range = 10
var player = null
var distance_to_player = 0

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	pass

func _physics_process(delta: float) -> void:
	handle_state()
	distance_to_player = body.global_position.distance_to(player.global_position)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

func handle_idle():
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Idle")
	if distance_to_player < vision_range:
		cur_state = state.CHASE


func handle_chase():
	# chase involves moving toward the player, when in range, switch to attack
	# this needs to loop while the chase is happening
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Run")
	
	navigation_agent.target_position = player.global_position
	var pos = navigation_agent.get_next_path_position()
	var dir: Vector3 = global_position.direction_to(pos)

	velocity.x = base_move_speed * dir.x
	velocity.z = base_move_speed * dir.z
	if distance_to_player < attack_range:
		cur_state = state.ATTACK



func handle_attack():
	if !animation_player.is_playing():
		animation_player.play("Armature|Rat_Attack")
	if distance_to_player > attack_range:
		cur_state = state.CHASE
