extends State

class_name StateIdle

func enter():
	print("entering idle")
	enemy.enter_idle()

func exit():
	print("exiting idle")

func update(_delta):
	enemy.handle_idle()

func handle_event(event: Events.type) -> State:
	match event:
		Events.type.DETECT_PLAYER:
			return StateChase.new(self.enemy)
		Events.type.DIE:
			return StateDead.new(self.enemy)
		_:
			return null
