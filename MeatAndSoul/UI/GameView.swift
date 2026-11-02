//
//  GameView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

struct GameView: View {
    @State var manager: LevelManager = .test

    var body: some View {
        SpriteRender(sprite: manager.level.tiles) { _, tiles in
            Color.brown.brightness(0.2)

            ForEach(tiles.addresses) { address in
                let tile = tiles.tiles[address]!
                GroundTileView(tile: tile)
            }

            ForEach(PlayerVariant.allCases.enumerated(), id: \.offset) { (_, variant) in
                if let player = manager.level.players[variant] {
                    PlayerView(player: player)
                }
            }
        }
    }
}

struct TestSprite: Sprite {
    var frame: CGRect
    var text: String
}
