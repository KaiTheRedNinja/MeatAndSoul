//
//  Obstacle.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 3/11/26.
//

import SwiftUI
import Combine

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

    @Environment(\.currentOffset) var timeOffset: TimeInterval

    var body: some View {
        SpriteRender(sprite: obstacle) { rect, _ in
            switch obstacle.variant {
            case .wall:
                Color(white: 0.2)
            case .ichor:
                Color.blue
                VStack(spacing: 0) {
                    let startIndex = Int(rect.minY / 10)
                    let endIndex = Int(rect.maxY / 10)
                    ForEach(startIndex..<endIndex, id: \.self) { index in
                        Color.purple
                            .opacity(0.8 + 0.2*sin(CGFloat(index) * 0.5 + timeOffset))
                    }
                }
            case .salt:
                Color(white: 0.8)
            case .lava:
                Color.red
            }
        }
    }
}

#Preview {
    @Previewable @State var lastUpdate: Date?
    @Previewable @State var manager: LevelManager = .test

    let gameTimer = Timer.publish(every: 1/60, on: .main, in: .default).autoconnect()

    VStack {
        SpriteRender(sprite: manager.level.tiles) { _, tiles in
            Color.brown.brightness(0.2)

            ForEach(tiles.addresses) { address in
                let tile = tiles.tiles[address]!
                GroundTileView(tile: tile)
            }

            ForEach(manager.level.obstacles) { obstacle in
                ObstacleView(obstacle: obstacle)
            }

            ForEach(manager.level.moveables) { moveable in
                MoveableView(moveable: moveable)
            }

            ForEach(manager.level.interactables) { interactable in
                InteractableView(interactable: interactable)
            }

            ForEach(PlayerVariant.allCases.enumerated(), id: \.offset) { (_, variant) in
                if let player = manager.level.players[variant] {
                    PlayerView(player: player)
                }
            }
        }
    }
    .onReceive(gameTimer) { date in
        lastUpdate = date
    }
    .environment(\.currentOffset, lastUpdate?.timeIntervalSinceReferenceDate ?? 0)
}
