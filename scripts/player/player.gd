extends CharacterBody3D

@onready var full_body_collision: CollisionShape3D = $StandingHitbox
@onready var half_body_collision: CollisionShape3D = $CrouchingHitbox
@onready var head: Node3D = $Neck/Head
@onready var neck: Node3D = $Neck
@onready var head_collision_ray: RayCast3D = $HeadCollisionRay
@onready var camera: Camera3D = $Neck/Head/Camera3D
@onready var health_bar: TextureProgressBar = $CanvasLayer/HealthBar
@onready var db_shotgun_shoot_anim: AnimationPlayer = $Neck/Head/Camera3D/double_barrel_shotgun/AnimationPlayer2
@onready var gun_barrel: RayCast3D = $Neck/Head/Camera3D/double_barrel_shotgun/RayCast3D

var bullet = load("res://assets/weapons/bullet.tscn")
var instance

# player vals
@export var max_health: float = 100.0
@export var cur_heatlh: float = 100.0

# movement vals
var free_look: bool = false
var free_look_tilt: float = 10.0
@export var cur_speed: float = 20.0
var base_move_speed: float = 20.0
var crouch_speed: float = base_move_speed * 0.5
var crouch_depth: float = -0.7
var lerp_speed: float = 6.0
var direction = Vector3.ZERO
var slide_threshold: float = base_move_speed * 0.55

var jump_velocity: float = 12.0
var jump_ascend: float = 35.0
var jump_descend: float = 40.0

enum player_movement {WALKING, CROUCHING, SLIDING, AWAIT_STAND}
var player_movement_state: player_movement = player_movement.WALKING

# POV vals
var mouse_sens: float = 0.1
var camera_anglev: float = 0.0

# control vals
var can_shoot: bool = true
var dead: bool = false

# this function runs once when the node enters the scene tree
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# this function runs whenever an input event occurs
func _input(event):
	if dead:
		return

	if event is InputEventMouseMotion:
		if free_look:
			neck.rotate_y(deg_to_rad(-1 * event.relative.x * mouse_sens))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-110), deg_to_rad(110))
		else:
			rotate_y(deg_to_rad(-1 * event.relative.x * mouse_sens))
			head.rotate_x(deg_to_rad(-1 * event.relative.y * mouse_sens))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
	# replace this with a switch after adding other controls
	if Input.is_action_pressed("crouch"):
		# do something here
		if get_magnitude(velocity.x, velocity.y, velocity.z) >= slide_threshold:
			player_movement_state = player_movement.SLIDING
			print("sliding now")
		player_movement_state = player_movement.CROUCHING
	if Input.is_action_just_released("crouch"):
		player_movement_state = player_movement.AWAIT_STAND
		
	if Input.is_action_pressed("free_look"):
		free_look = true
	elif Input.is_action_just_released("free_look"):
		free_look = false
		
	
		

# on every rendered frame (expensive)
func _process(delta):
	update_ui()
	if dead:
		return
	elif Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		restart()
	elif Input.is_action_just_pressed("shoot"):
		shoot()

# runs before every physics step (fixed at 60 times / sec)
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= jump_ascend * delta
		else:
			velocity.y -= jump_descend * delta

	handle_movement_state(delta)
	
	if Input.is_action_just_pressed("shoot"):
		if !db_shotgun_shoot_anim.is_playing():
			db_shotgun_shoot_anim.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
			
	if !free_look:
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta * lerp_speed)
	# rotate camera with free look (probably put this somewhere else later)
	camera.rotation.z = -deg_to_rad(neck.rotation.y * free_look_tilt)
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_fwd", "move_bwd")
	direction = lerp( direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)

# this is fine if we are in WALKING, CROUCHING, or SPRINTING
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
	else:
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
	
	move_and_slide()

# later separate one time things with things that need to happen at each physics step
# so that we have 2 functions
func handle_movement_state(delta):
	match player_movement_state:
		player_movement.CROUCHING, player_movement.AWAIT_STAND:
			if player_movement_state == player_movement.AWAIT_STAND && !head_collision_ray.is_colliding():
				player_movement_state = player_movement.WALKING
			cur_speed = crouch_speed
			head.position.y = lerp(head.position.y, crouch_depth, delta * lerp_speed)
			full_body_collision.disabled = true
			half_body_collision.disabled = false
			
		player_movement.SLIDING:
			head.position.y = lerp(head.position.y, crouch_depth, delta * lerp_speed)
			full_body_collision.disabled = true
			half_body_collision.disabled = false
			
		player_movement.WALKING:
			cur_speed = base_move_speed
			head.position.y = lerp(head.position.y, 0.0, delta * lerp_speed)
			full_body_collision.disabled = false
			half_body_collision.disabled = true
		_:
			# default to walking
			player_movement_state = player_movement.WALKING


func restart():
	get_tree().reload_current_scene()

func shoot():
	if !can_shoot:
		return

func kill():
	dead = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func take_damage():
	pass
	
func heal():
	pass

func update_ui():
	if health_bar:
		health_bar.value = cur_heatlh

func get_magnitude(x: float, y: float, z: float) -> float:
	return sqrt((x*x) + (y*y) + (z*z))
