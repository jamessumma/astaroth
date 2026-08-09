extends State

class_name StateExecAttack

func enter():
  print("entering exec attack")
  enemy.enter_exec_attack()

func exit():
  print("exiting exec attack")

func update(delta):
  enemy.update_state_attack(delta)
  pass

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.ATTACK_FINISHED:
      return StateChase.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null