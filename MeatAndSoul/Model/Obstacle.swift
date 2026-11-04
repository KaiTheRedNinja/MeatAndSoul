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
