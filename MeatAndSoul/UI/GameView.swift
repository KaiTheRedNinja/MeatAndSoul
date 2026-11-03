//
//  GameView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI
import Combine

struct GameView: View {
    @State var manager: LevelManager = .test

    var gameTimer = Timer.publish(every: 1/60, on: .main, in: .default).autoconnect()
    @State var lastUpdate: Date?

    var body: some View {
        SpriteRender(sprite: manager.level.tiles) { _, tiles in
            Color.brown.brightness(0.2)

            ForEach(tiles.addresses) { address in
                let tile = tiles.tiles[address]!
                GroundTileView(tile: tile)
            }

            ForEach(manager.level.obstacles) { obstacle in
                ObstacleView(obstacle: obstacle)
            }

            ForEach(PlayerVariant.allCases.enumerated(), id: \.offset) { (_, variant) in
                if let player = manager.level.players[variant] {
                    PlayerView(player: player)
                }
            }
        }
        .background {
            KeyCaptureView { event in
                manager.update(forKeyEvent: event)
            }
        }
        .onReceive(gameTimer) { date in
            defer { lastUpdate = date }
            if let lastUpdate {
                manager.tick(dt: date.timeIntervalSince(lastUpdate))
            }
        }
    }
}

struct TestSprite: Sprite {
    var frame: CGRect
    var text: String
}
