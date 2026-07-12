extends State

class_name StateChooseAttack

func enter():
  print("entering choose attack")
  enemy.handle_choose_attack()
  enemy.enter_choose_attack()

func exit():
  print("exiting choose attack")

func update(delta):
  pass

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.ATTACK_CHOSEN:
      return StateReposition.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null