# MeatAndSoul
A zombie and a ghost yearn to be one again.

## Why did I make this?
I haven't been following the themes, but this week I decided that I would give it a try. I saw a shower thoughts post suggesting that zombies are just bodies without a soul, and that ghosts are souls without a body. Based on that idea, I created this game, where you play as a zombie and a ghost that need to recombine to leave a graveyard. The ghost and zombie have different interactions with obstacles, for example ghosts can pass through walls while zombies cannot, whereas zombies can swim through ichor while ghosts cannot.

## What features does this game have?
- Obstacles
- Levers, buttons, gates, and bridges
- The three player types (ghost, zombie, human)

## What would I like the game to have?
This game is quite incomplete, I would preferably have added:
- Sound
- Movement-based obstacles, such as moving platforms
- Things that can actually kill the player, rather than just blocking them
- Make the graveyard look more graveyard-like
- Wayyyy more levels

## How to Play
1. Download the macOS executable from the GitHub release
2. Run the executable
3. Follow the tutorial!

## Implementation Details
Built using Swift and SwiftUI, all assets are made using primitive shapes. Because I'm too lazy to figure out how to get Lapse working and I don't have a tablet anyway :P

## Gameplay Plan and Details
Roughly inspired by fireboy and watergirl. You play as person who has been struck by lightning, split into a zombie (Meat, arrow keys) and a ghost (Soul, WASD). They must find their way back together and exit the graveyard.
There are four different types of obstacles:

| Obstacle | Ghost | Zombie | Person |
| --- | --- | --- | --- |
| Wall | Fazes through | Stopped | Stopped |
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
  - [x] Collisions
  - [x] Make them look good
- [x] Tiles
  - [x] Dirt
- [x] Obstacles
  - [x] Decide whether we want the walls/ichor/salt/lava to be considered tiles or obstacles
  - [x] Wall
  - [x] Ichor
  - [x] Salt
  - [x] Lava
  - [x] Multiple orientations for all of the walls (2^4 = 16 possible states)
  - [x] Movable obstacles, e.g. doors (opens walls), bridges (over ichor, lava), fans (breaks salt)
  - [x] Trigger items, e.g. levers and buttons
- [x] Game loop
  - [x] Restarting
  - [x] Win detection (when human exits graveyard)
