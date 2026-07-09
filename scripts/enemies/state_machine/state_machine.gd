extends RefCounted

class_name StateMachine

var cur_state: State
var enemy: Enemy

func _init(enemy: Enemy):
  self.enemy = enemy
  self.cur_state = StateIdle.new(enemy)

func trigger_event(event):
  var next = cur_state.handle_event(event)
  if next:
    change_state(next)

func change_state(state: State):
  cur_state.exit()
  cur_state = state
  cur_state.enter()
