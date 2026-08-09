class_name Attack

extends RefCounted

@export var attack_name: String
@export var attack_duration: float = 1.0
@export var min_range: float
@export var max_range: float
@export var base_weight: float = 1.0
@export var cur_weight: float = 1.0
@export var base_damage: float = 1.0
@export var knockback: bool = false
@export var speed_mod: float = 1.0

@export var x_vel_mult: float = 1.0
@export var y_vel_mult: float = 1.0
@export var z_vel_mult: float = 1.0
