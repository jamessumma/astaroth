extends Enemy

class_name Rat

@onready var animation_player = $RatModel/AnimationPlayer

var attack_range = 0
var vision_range = 0

func handle_idle():
	animation_player.play("Armature|Rat_Idle")
	pass

func handle_chase():
	# chase involves moving toward the player, when in range, switch to attack
	# this needs to loop while the chase is happening
	animation_player.play("Armature|Rat_Run")
	pass

func handle_attack():
	animation_player.play("Armature|Rat_Attack")
	pass
