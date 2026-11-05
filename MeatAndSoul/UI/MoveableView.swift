//
//  MoveableView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 5/11/26.
//

import SwiftUI

struct MoveableView: View {
    var moveable: MoveableObstacle

    var body: some View {
        SpriteRender(sprite: moveable) { size, _ in
            switch moveable.variant {
            case .door:
                if !moveable.isOpen {
                    // acts the same as a wall
                    Color.orange.saturation(2)

                    Color(white: 0.2)
                        .padding(10)
                } else {
                    // its open!
                    Color.black.opacity(0.2)
                }
            case .bridge:
                if moveable.isOpen {
                    // acts the same as dirt
                    Color.orange
                } else {
                    // um just let it be known that its here
                    Color.orange.opacity(0.5)
                }
            }
        }
    }
}
