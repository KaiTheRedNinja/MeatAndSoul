//
//  Decoration.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 8/11/26.
//

import Foundation

struct DecorationObstacle: Sprite, Identifiable {
    var id: UUID = .init()
    var frame: CGRect
    var variant: DecorationVariant
}

enum DecorationVariant {
    case text(String)
}
