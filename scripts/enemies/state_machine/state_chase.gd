extends RefCounted

class_name StateChase

func enter():
  print("entering chase")

func exit():
  print("exiting chase")

func update(delta):
  pass

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.IN_RANGE:
      return StateAttack.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null