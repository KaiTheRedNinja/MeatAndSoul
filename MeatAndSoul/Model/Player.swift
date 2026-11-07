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

    @State var bounce: Bool = false

    var body: some View {
        SpriteRender(sprite: player) { size, _ in
            switch player.variant {
            case .zombie:
                Capsule()
                    .fill(Color.green)
                    .brightness(0.2)
            case .ghost:
                Path { path in
                    // curved head
                    let width = size.width
                    let height = size.height
                    let topRadius = width/2
                    path.move(to: .init(x: 0, y: topRadius))
                    path.addArc(center: .init(x: topRadius, y: topRadius), radius: topRadius, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)

                    path.addLine(to: .init(x: width, y: height))

                    // zig zags!
                    let zigzagCount = 5
                    let zigzagWidth = width / CGFloat(zigzagCount)

                    for index in 0..<zigzagCount {
                        let offsetFromRhs = CGFloat(index) * zigzagWidth
                        path.addLine(to: .init(x: width - offsetFromRhs - zigzagWidth/2, y: height - zigzagWidth))
                        path.addLine(to: .init(x: width - offsetFromRhs - zigzagWidth, y: height))
                    }

                    // close subpath
                    path.addLine(to: .init(x: 0, y: height))
                    path.closeSubpath()

                    // eyes
                    let eyeWidth = width * 0.2
                    let eyeHeight = width * 0.3
                    path.addEllipse(in: .init(
                        x: width * 0.2,
                        y: topRadius - eyeHeight/2,
                        width: eyeWidth,
                        height: eyeHeight
                    ))

                    path.addEllipse(in: .init(
                        x: width * 0.8 - eyeWidth,
                        y: topRadius - eyeHeight/2,
                        width: eyeWidth,
                        height: eyeHeight
                    ))
                }
                .stroke(Color.gray)
                .fill(Color.white, style: .init(eoFill: true))
                .opacity(0.5)
                .offset(y: bounce ? size.height * 0.05 : size.height * -0.05)
            case .human:
                Capsule()
                    .fill(Color.yellow)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                bounce = true
            }
        }
    }
}

#Preview {
    ZStack(alignment: .topLeading) {
        GroundTileView(tile: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .dirt))
        PlayerView(player: .init(frame: .init(x: 20, y: 20, width: 60, height: 60), variant: .ghost))
    }
    .padding(10)
}
