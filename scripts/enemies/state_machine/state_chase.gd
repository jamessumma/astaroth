extends State

class_name StateChase

# the purpose of this is to just run towards the player up until a certain distance
# ie, just get to the fight
func enter():
	print("entering chase")
	enemy.enter_chase()

func exit():
	print("exiting chase")
	enemy.exit_move_state()
	enemy.set_pull_vector_stop()


func update(delta):
	enemy.handle_chase()
	enemy.set_pull_to_player()
	enemy.look_at_slerp(delta)

func handle_event(event: Events.type) -> State:
	match event:
		Events.type.IN_COMBAT_RANGE:
			return StateChooseAttack.new(self.enemy)
		Events.type.DIE:
			return StateDead.new(self.enemy)
		_:
			return null
