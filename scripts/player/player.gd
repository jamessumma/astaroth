extends CharacterBody3D

@onready var camera: Camera3D = $Head/Camera3D
@onready var stamina_bar: TextureProgressBar = $CanvasLayer/StaminaBar
@onready var health_bar: TextureProgressBar = $CanvasLayer/HealthBar


# player vals
@export var max_health: float = 100.0
@export var cur_heatlh: float = 100.0
@export var max_stamina: float = 100.0
@export var cur_stamina: float = 100.0
var stamina_drain_speed: float = 0.2

# movement vals
@export var cur_speed: float = 5.0
var walking_speed: float = 4.0
var sprint_speed: float = 10.0
var crouch_speed: float = 3.0
var jump_velocity: float = 4.5
var is_sprinting: bool = false
var is_crouching: bool = false

# POV vals
var mouse_sens: float = 0.2
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
		rotation_degrees.y -= event.relative.x * mouse_sens
		$Head.rotation.x -= event.relative.y * mouse_sens * 0.01
		$Head.rotation.x = clamp($Head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	# replace this with a switch after adding other controls
	if Input.is_action_just_pressed("sprint"):
		is_sprinting = not is_sprinting
		

# on every rendered frame (expensive)
func _process(delta):
	print(cur_speed)
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
		velocity += get_gravity() * delta

	handle_sprint()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_fwd", "move_bwd")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * cur_speed
		velocity.z = direction.z * cur_speed
	else:
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		velocity.z = move_toward(velocity.z, 0, cur_speed)
		is_sprinting = false

	move_and_slide()

func handle_sprint():
	if is_sprinting:
		cur_stamina -= stamina_drain_speed
		if cur_stamina <= 0:
			is_sprinting = false
			cur_speed = walking_speed
		else:
			cur_speed = sprint_speed
	else:
		cur_speed = walking_speed
		if cur_stamina < max_stamina:
			cur_stamina += 1


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
	if stamina_bar:
		stamina_bar.value = cur_stamina
	if health_bar:
		health_bar.value = cur_heatlh
