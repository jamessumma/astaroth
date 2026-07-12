extends State

class_name StateReposition

# the purpose of this is to get in range of the chosen attack
# ie, move until in range of chosen attack, or move to specific position
func enter():
  print("entering reposition")
  enemy.enter_reposition()

func exit():
  print("exiting reposition")
  enemy.exit_move_state()

func update(delta):
  enemy.handle_reposition()
  enemy.handle_move(delta)
  enemy.look_at_slerp(delta)

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.IN_ATTACK_RANGE:
      return StateExecAttack.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null