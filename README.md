# MeatAndSoul
A zombie and a ghost yearn to be one again.

## Gameplay Plan
Roughly inspired by fireboy and watergirl. You play as person who has been struck by lightning, split into a zombie (Meat, arrow keys) and a ghost (Soul, WASD). They must find their way back together and exit the graveyard.
There are five different types of ground tiles:

| Obstacle | Ghost | Zombie | Person |
| --- | --- | --- | --- |
| Dirt | Walks on | Walks on | Walks on |
|  Wall| Fazes through | Stopped | Stopped |
| Ichor | Stopped | Swims through |  Stopped|
| Salt | Stopped | Stopped | Walks over |
|  Lava| Stopped | Stopped | Stopped |

There will probably be things like drawbridges and doors, working as a puzzle game. The user wins the level after having the zombie and ghost meet (where they fuse into a human), then exiting the graveyard.
Yes, Ichor was shamelessly copied from Minecraft. I wanted to use a river e.g. Styx from Greek mythology, but eh theres no term for the water.

## Todo List
Basic functionality:
- [x] Players and user keyboard input
  - [x] Ghost
  - [x] Zombie
  - [x] Human
  - [ ] Collisions
- [ ] Tiles
  - [ ] Dirt
  - [ ] Wall
  - [ ] Ichor
  - [ ] Salt
  - [ ] Lava
- [ ] Obstacles
  - [ ] Decide whether we want the walls/ichor/salt/lava to be considered tiles or obstacles
    - [ ] Multiple orientations
  - [ ] Movable obstacles, e.g. doors (opens walls), bridges (over ichor, lava), fans (breaks salt)
  - [ ] Trigger items, e.g. levers and buttons
- [ ] Game loop
  - [ ] Restarting
  - [ ] Win detection (when human exits graveyard)
