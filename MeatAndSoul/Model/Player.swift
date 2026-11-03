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
}

enum PlayerVariant: CaseIterable {
    case zombie
    case ghost
    case human
}

struct PlayerView: View {
    var player: Player

    var body: some View {
        SpriteRender(sprite: player) { size, _ in
            switch player.variant {
            case .zombie:
                Capsule()
                    .fill(Color.green)
                    .brightness(0.2)
            case .ghost:
                Capsule()
                    .fill(Color.white)
                    .opacity(0.5)
            case .human:
                Capsule()
                    .fill(Color.yellow)
            }
        }
    }
}
