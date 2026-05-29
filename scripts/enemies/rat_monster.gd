extends Node3D

@onready var animation_player = $AnimationPlayer
var time_passed: float = 0.0
const ATTACK_INTERVAL: float = 5.0

func _ready() -> void:
	animation_player.play("metarig|Attack 2 fists")

# _process runs every single frame
func _process(delta: float) -> void:
	time_passed += delta
	
	if time_passed >= ATTACK_INTERVAL:
		animation_player.play("metarig|Attack 2 fists")
		print("thing played")
		time_passed = 0.0


func _on_area_3d_body_part_hit(dam: Variant) -> void:
	print("enemy hit detected")
	pass # Replace with function body.
