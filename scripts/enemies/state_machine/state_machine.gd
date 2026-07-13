extends RefCounted

class_name StateMachine

var cur_state: State
var enemy: Enemy
var pending: State = null

func _init(enemy: Enemy):
	self.enemy = enemy
	self.cur_state = StateIdle.new(enemy)
	cur_state.enter()

func trigger_event(event):
	var next = cur_state.handle_event(event)
	if next:
		pending = next

func change_state(state: State):
	cur_state.exit()
	cur_state = state
	cur_state.enter()

func update(delta: float):
	cur_state.update(delta)
	flush()

func flush():
	while pending:
		var next = pending
		pending = null
		change_state(next)
