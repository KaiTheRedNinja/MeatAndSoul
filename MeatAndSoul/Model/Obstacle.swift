//
//  Obstacle.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 3/11/26.
//

import Foundation

struct Obstacle: Sprite, Identifiable {
    var id: UUID = .init()
    var frame: CGRect
    var variant: ObstacleVariant
    var orientation: SpriteOrientation
    var joints: Set<SpriteOrientation>
}

enum ObstacleVariant {
    case wall
    case ichor
    case salt
    case lava
}
