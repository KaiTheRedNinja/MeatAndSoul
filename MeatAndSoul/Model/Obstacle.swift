//
//  Obstacle.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 3/11/26.
//

import SwiftUI

struct Obstacle: Sprite, Identifiable {
    var id: UUID = .init()
    var frame: CGRect
    var variant: ObstacleVariant
    var orientation: SpriteOrientation
}

enum ObstacleVariant {
    case wall
    case ichor
    case salt
    case lava
}

enum SpriteOrientation {
    // faces up
    case up
    // faces down
    case down
    // faces left
    case left
    // faces right
    case right
}

struct ObstacleView: View {
    var obstacle: Obstacle

    var body: some View {
        SpriteRender(sprite: obstacle) { size, _ in
            switch obstacle.variant {
            case .wall:
                Color(white: 0.2)
            case .ichor:
                Color.blue
            case .salt:
                Color(white: 0.8)
            case .lava:
                Color.red
            }
        }
    }
}

struct Interactable: Sprite, Identifiable {
    var id: UUID = .init()

    /// The item that it is linked to
    var linked: String
    /// The frame of the interactable
    var frame: CGRect
    /// What interactable this is
    var variant: InteractableVariant
    /// Whether or not it is currently active.
    ///
    /// For a lever, this may be set to `true` at spawn-time. For a button, this value will
    /// be set to false unless the player is currently holding it down.
    var active: Bool
    /// The direction of this interactable
    var orientation: SpriteOrientation
}

enum InteractableVariant {
    case button
    case lever
}

struct MoveableObstacle: Sprite, Identifiable {
    var id: UUID = .init()

    /// The item that it is linked to
    var linked: String

    var frame: CGRect
    /// What moveable this is
    var variant: MoveableVariant

    /// Whether this obstacle defaults to closed.
    ///
    /// - If set to `true`, the obstacle will be closed when its input is `false` (not pressed), and open when its input is `true` (pressed)
    /// - If set to `false`, the obstacle will be open when its input is `false` (not pressed), and closed when its input is `true` (pressed)
    var defaultClosed: Bool

    /// If this obstacle is currently open
    var isOpen: Bool

    /// The current behaviour of the moveable
    var currentBehaviour: MoveableBehaviour { isOpen ? variant.openBehaviour : variant.closedBehaviour }
}

enum MoveableVariant {
    case door // opens walls
    case bridge // clears ditches

    /// What obstacle this behaves like when closed
    var closedBehaviour: MoveableBehaviour {
        switch self {
        case .door: .obstacle(.wall)
        case .bridge: .obstacle(.ichor)
        }
    }

    /// What obstacle this behaves like when open
    var openBehaviour: MoveableBehaviour {
        switch self {
        case .door: .movementAllowed // all can cross
        case .bridge: .movementAllowed // all can cross
        }
    }
}

enum MoveableBehaviour {
    /// Any obstacle inside the bounds of this moveable are ignored
    case movementAllowed
    /// This moveable acts like an obstacle
    case obstacle(ObstacleVariant)
}

struct MoveableView: View {
    var moveable: MoveableObstacle

    var body: some View {
        SpriteRender(sprite: moveable) { size, _ in
            switch moveable.variant {
            case .door:
                if !moveable.isOpen {
                    // acts the same as a wall
                    Color.orange.saturation(2)

                    Color(white: 0.2)
                        .padding(10)
                } else {
                    // its open!
                    Color.black.opacity(0.2)
                }
            case .bridge:
                if moveable.isOpen {
                    // acts the same as dirt
                    Color.orange
                } else {
                    // um just let it be known that its here
                    Color.orange.opacity(0.5)
                }
            }
        }
    }
}
