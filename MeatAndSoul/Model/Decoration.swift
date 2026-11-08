//
//  Decoration.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 8/11/26.
//

import Foundation
import SwiftUI

struct Decoration: Sprite, Identifiable {
    var id: UUID = .init()
    var frame: CGRect
    var variant: DecorationVariant
}

enum DecorationVariant {
    case text(TextDecorationInfo)
}

struct TextDecorationInfo {
    var text: String
    var fontSize: CGFloat? = nil // if nil, will auto adjust
    var backgroundColor: Color = Color.init(white: 0.25)
    var textColor: Color = .white
}
