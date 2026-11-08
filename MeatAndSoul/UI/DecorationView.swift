//
//  DecorationView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 8/11/26.
//

import SwiftUI

struct DecorationView: View {
    var decor: Decoration

    var body: some View {
        SpriteRender(sprite: decor) { rect, _ in
            switch decor.variant {
            case let .text(info):
                Text(info.text)
                    .font(.system(size: info.fontSize ?? 100, design: .serif))
                    .minimumScaleFactor(info.fontSize == nil ? 0.01 : 1) // adjustable size
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .foregroundStyle(info.textColor)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(info.backgroundColor)
                    }
            }
        }
    }
}

#Preview {
    VStack {
        ZStack(alignment: .topLeading) {
            DecorationView(
                decor: .init(
                    frame: .init(x: 0, y: 0, width: 200, height: 100),
                    variant: .text(
                        .init(text: "Hello, World!")
                    )
                )
            )
        }
        ZStack(alignment: .topLeading) {
            DecorationView(
                decor: .init(
                    frame: .init(x: 0, y: 0, width: 200, height: 100),
                    variant: .text(
                        .init(
                            text: "This is a test is a much longer text view with a lot more text",
                            backgroundColor: Color.red,
                            textColor: Color.blue
                        )
                    )
                )
            )
        }
        ZStack(alignment: .topLeading) {
            DecorationView(
                decor: .init(
                    frame: .init(x: 0, y: 0, width: 200, height: 100),
                    variant: .text(
                        .init(
                            text: "This text has fixed size",
                            fontSize: 10,
                            backgroundColor: Color(white: 0.25),
                            textColor: Color.primary
                        )
                    )
                )
            )
        }
    }
    .padding(10)
}
