extends RefCounted

class_name State

var enemy: Enemy

func _init(enemy_param):
  self.enemy = enemy_param

func enter():
  pass

func exit():
  pass

func update(_delta: float):
  pass

func handle_event(_event: Events.type):
  pass
