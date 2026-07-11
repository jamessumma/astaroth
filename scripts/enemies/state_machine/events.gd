class_name Events

enum type {
  ATTACK_CHOSEN,
  ATTACK_FINISHED,
  DETECT_PLAYER, 
  DIE,
  FLINCH_FINISH,
  FLINCHING_HIT,
  HIT,
  IN_ATTACK_RANGE, # signals that the enemy has entered range to execute chosen attack
  IN_COMBAT_RANGE # signals that the enemy has entered range to choose an attack
}