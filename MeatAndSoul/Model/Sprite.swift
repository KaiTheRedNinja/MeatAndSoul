//
//  Sprite.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

protocol Sprite {
    var frame: CGRect { get }
}

extension Sprite {
    func intersects(other: any Sprite) -> Bool {
        self.frame.intersects(other.frame)
    }
    func contains(other: any Sprite) -> Bool {
        self.frame.contains(other.frame)
    }
}

// render the sprite into the frame
struct SpriteRender<S: Sprite, V: View>: View {
    var sprite: S
    var content: (CGSize, S) -> V

    init(sprite: S, @ViewBuilder content: @escaping (CGSize, S) -> V) {
        self.sprite = sprite
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            content(sprite.frame.size, sprite)
        }
        .frame(width: sprite.frame.width, height: sprite.frame.height)
        .offset(x: sprite.frame.minX, y: sprite.frame.minY)
    }
}
