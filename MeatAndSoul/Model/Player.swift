//
//  Player.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

struct Player: Sprite, Identifiable {
    var id: UUID = .init()
    var frame: CGRect
    var variant: PlayerVariant
    /// Which way the player is moving, or `nil` if not in motion
    var movementDirection: SpriteOrientation?
}

enum PlayerVariant: CaseIterable {
    case zombie
    case ghost
    case human
}
