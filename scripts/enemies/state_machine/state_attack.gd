extends RefCounted

class_name StateAttack

func enter():
  print("entering attack")

func exit():
  print("exiting attack")

func update(delta):
  pass

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.ATTACK_FINISHED:
      return StateChase.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null