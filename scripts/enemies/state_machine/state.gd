extends RefCounted

class_name State

var enemy: Enemy

func _init(enemy):
  self.enemy = enemy

func enter():
  pass

func exit():
  pass

func update(delta: float):
  pass

func handle_event(event: Events.type):
  pass