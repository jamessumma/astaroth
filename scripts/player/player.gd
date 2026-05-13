extends CharacterBody3D

@onready var camera: Camera3D = $Head/Camera3D

# movement vals
@export var cur_speed: float = 5.0
var walking_speed: float = 5.0
var sprint_speed: float = 7.5
var crouch_speed: float = 7.5
var jump_velocity: float = 4.5

# POV vals
var mouse_sens: float = 0.5
var camera_anglev: float =0.0

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
		

# on every rendered frame (expensive)
func _process(delta):
	if dead:
		return
	else if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	else if Input.is_action_just_pressed("restart"):
		restart()
	else if Input.is_action_just_pressed("shoot"):
		shoot()

# runs before every physics step (fixed at 60 times / sec)
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

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

	move_and_slide()



func restart():
	get_tree().reload_current_scene()

func shoot():
	if !can_shoot:
		return


func kill():
	dead = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
