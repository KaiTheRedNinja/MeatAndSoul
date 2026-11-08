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

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Text(manager.level.name)
                    .font(.system(size: 70, design: .serif))
                    .minimumScaleFactor(0.5)

                Spacer()
            }
            .overlay(alignment: .trailing) {
                HStack {
                    Button {
                        manager.restart()
                    } label: {
                        Text("Restart")
                            .font(.system(size: 20, design: .serif))
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(white: 0.25))
                            }
                    }
                    .buttonStyle(.plain)

                    Button {
                        // TODO: show level view
                    } label: {
                        Text("Levels")
                            .font(.system(size: 20, design: .serif))
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(white: 0.25))
                            }
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()

            GeometryReader { proxy in
                let screenSize = manager.level.tiles.frame.size

                let scale = min(
                    proxy.size.width / screenSize.width,
                    proxy.size.height / screenSize.height,
                )

                ZStack(alignment: .center) {
                    LevelView(manager: manager)
                }
                .border(Color.green)
                .frame(width: screenSize.width, height: screenSize.height, alignment: .center)
                .clipped()
                .scaleEffect(.init(width: scale, height: scale), anchor: .center)
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .border(Color.cyan)
        }
        .padding(50)
    }
}

struct LevelView: View {
    @State var manager: LevelManager

    var gameTimer = Timer.publish(every: 1/120, on: .main, in: .default).autoconnect()
    @State var lastUpdate: Date?

    var body: some View {
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

                ForEach(manager.level.decorations) { decoration in
                    DecorationView(decor: decoration)
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
