extends Area3D

class_name BodyPart

signal body_part_hit(dam, part)

const DEATH_SPLATTER = preload("res://scenes/effects/blood_splatter.tscn")

var last_hit_point_local: Vector3
var last_hit_normal_local: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func crit(damage: float, hit_point: Vector3, hit_normal: Vector3):
	_cache_hit(hit_point, hit_normal)
	emit_signal("body_part_hit", damage, self)

func hit(damage: float, hit_point: Vector3, hit_normal: Vector3):
	_cache_hit(hit_point, hit_normal)
	emit_signal("body_part_hit", damage, self)

func _cache_hit(hit_point: Vector3, hit_normal: Vector3):
	last_hit_point_local = to_local(hit_point)
	last_hit_normal_local = global_transform.basis.transposed() * hit_normal

func spawn_death_splatter():
	var death_splatter_inst = DEATH_SPLATTER.instantiate()
	add_child(death_splatter_inst)
	death_splatter_inst.position = last_hit_point_local
	death_splatter_inst.look_at(death_splatter_inst.global_position + last_hit_normal_local, Vector3.UP)
	death_splatter_inst.emitting = true
	print("death splatter")
