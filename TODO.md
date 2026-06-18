## TODO 
### Movement and Physics
- Fix issue where enemies wont walk up steep slopes
- create step assist node, add it to player and enemies
- Add field to enable enemies to jump places they cant step up to
- Fix issue where you can walk around enemies and they wont turn to face you

### Visuals
- redo shader so we can use transparent textures
- test out vhs filter

### Enemy Features
- move rat hitboxes to skeleton so they move with animations
- floating health bar
- enemies are made aware of you when you shoot them, not just when you walk closely
- enemy should have an attack hitbox
- enemy attacks should deal damage to the player

### Weapons
- Fix make it so bullet doesn't appear to spawn inside the gun
- Add multiple bullets that shoot out in a cone
- Fix issue where shooting enemies too closely doesnt register
- Add ricochet bullets upgrade
- Add exploding bullets upgrade

### Code
- Refactor player
- Assign mesh layers to game_manager
- refactor project structure
- pick a design pattern for enemy variants

### Map
- Pick an algorithm for node branching
- export office from blender
- export sewer from blender