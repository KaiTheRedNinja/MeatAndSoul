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

    var gameTimer = Timer.publish(every: 1/120, on: .main, in: .default).autoconnect()
    @State var lastUpdate: Date?

    var body: some View {
        VStack {
            Button("Restart") {
                manager.restart()
            }

            SpriteRender(sprite: manager.level.tiles) { _, tiles in
                Color.brown.brightness(0.2)

                ForEach(tiles.addresses) { address in
                    let tile = tiles.tiles[address]!
                    GroundTileView(tile: tile)
                }

                ForEach(manager.level.obstacles) { obstacle in
                    ObstacleView(obstacle: obstacle)
                }

//                // DEBUG: hitboxes for obstacles
//                ForEach(manager.level.obstacles) { obstacle in
//                    SpriteRender(sprite: obstacle) { _, _ in
//                        Rectangle()
//                            .stroke(Color.cyan)
//                    }
//                }

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
            .background {
                KeyCaptureView { event in
                    manager.keys.update(forKeyEvent: event)
                }
            }
            .onReceive(gameTimer) { date in
                defer { lastUpdate = date }
                if let lastUpdate {
                    manager.tick(dt: date.timeIntervalSince(lastUpdate))
                }
            }
        }
        .environment(\.currentOffset, lastUpdate?.timeIntervalSinceReferenceDate ?? 0)
    }
}

struct TestSprite: Sprite {
    var frame: CGRect
    var text: String
}

extension EnvironmentValues {
    @Entry var currentOffset: TimeInterval = 0
}

extension View {
    @inlinable
    public func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}
