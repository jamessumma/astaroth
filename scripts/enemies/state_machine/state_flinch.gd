extends State

class_name StateFlinch

func enter():
  print("entering flinch")
  enemy.enter_flinch()

func exit():
  print("exiting choose attack")

func update(delta):
  pass

func handle_event(event: Events.type) -> State:
  match event:
    Events.type.FLINCH_FINISH:
      return StateChase.new(self.enemy)
    Events.type.DIE:
      return StateDead.new(self.enemy)
    _:
      return null