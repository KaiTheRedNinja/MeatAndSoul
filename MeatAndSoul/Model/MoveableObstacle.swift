//
//  MoveableObstacle.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 4/11/26.
//

import SwiftUI

struct MoveableObstacle: Sprite, Identifiable {
    var id: UUID = .init()

    /// The item that it is linked to
    var linked: String

    var frame: CGRect
    /// What moveable this is
    var variant: MoveableVariant
    /// What direction it is facing
    var orientation: SpriteOrientation

    /// Whether this obstacle defaults to closed.
    ///
    /// - If set to `true`, `isOpen` will follow the `active` property of its linked Interactable
    /// - If set to `false`, `isOpen` will be the inverse of the `active` property of its linked Interactable (i.e. `!active`)
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

enum MoveableBehaviour: Equatable {
    /// Any obstacle inside the bounds of this moveable are ignored
    case movementAllowed
    /// This moveable acts like an obstacle
    case obstacle(ObstacleVariant)
}
