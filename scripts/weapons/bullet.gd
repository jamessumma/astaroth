extends Node3D

const SPEED: float = 40.0

var damage: float = 1.0
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray: RayCast3D = $RayCast3D
@onready var sparks: GPUParticles3D = $GPUParticles3D
@onready var blood_splatter: GPUParticles3D = $BloodSplatter
var has_impacted: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray.collide_with_areas = true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, SPEED) * delta
	if ray.is_colliding():
		print("ray is colliding with: ", ray.get_collider())
		handle_impact()	

func _on_timer_timeout():
	queue_free()
	
func handle_impact():
	if has_impacted:
		return
	
	has_impacted = true
		
	var collider = ray.get_collider()
	var particles = sparks
	
	if collider and collider.has_method("hit"):
		# Assuming your body_part.gd script has a hit() function, 
		# or you can call a custom method there to trigger the signal
		collider.hit(damage)
		particles = blood_splatter
	
	# get point of the collision
	var hit_point = ray.get_collision_point()
	var hit_normal = ray.get_collision_normal()
	
	# detach the particles from the bullet's transform
	particles.set_as_top_level(true)
	
	# move the particles to the exact hit point
	particles.global_position = hit_point
	
	# make explosion face away from the surface
	if hit_normal != Vector3.UP and hit_normal != Vector3.DOWN:
		particles.look_at(hit_point + hit_normal, Vector3.UP)

	particles.emitting = true
	mesh.visible = false
	set_physics_process(false)
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
