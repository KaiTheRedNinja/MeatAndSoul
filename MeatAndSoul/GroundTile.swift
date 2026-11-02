//
//  GroundTile.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

struct GroundTile: Sprite {
    var frame: CGRect
    var variant: GroundTileVariant
}

enum GroundTileVariant {
    case dirt
    case wall
    case ichor
    case salt
    case lava
}

struct GroundTileView: View {
    var tile: GroundTile

    var body: some View {
        SpriteRender(sprite: tile) { size, _ in
            switch tile.variant {
            case .dirt:
                Color.brown
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
