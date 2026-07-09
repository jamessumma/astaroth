extends RefCounted

class_name StateDead

func enter():
  print("entering dead")


func update(delta):
  # if death anim is done, free the queue
  pass

func finish():
  self.enemy.queue_free()