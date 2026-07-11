extends State

class_name StateChase

# the purpose of this is to just run towards the player up until a certain distance
# ie, just get to the fight
func enter():
  print("entering chase")
  enemy.enter_chase()

func exit():
  print("exiting chase")


func update(delta):
  enemy.handle_chase()
  enemy.handle_move(delta)
  enemy.look_at_slerp(delta)

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.IN_COMBAT_RANGE:
      return StateChooseAttack.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null