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
                ZStack(alignment: .topLeading) {
                    let width = size.width
                    let height = size.height

                    let frontLeg = 0.5 // flip if going left rather than right
                    let backLeg = 0.45

                    // legs
                    Capsule()
                        .fill(Color.green)
                        .brightness(-0.25) // back leg is slightly darker
                        .frame(width: width * 0.2, height: height * 0.5)
                        .rotationEffect(.degrees(bounce ? 15 : -15), anchor: .top)
                        .offset(x: width * (bounce ? 0.2 : 0.6), y: height * (bounce ? frontLeg : backLeg))
                    Capsule()
                        .fill(Color.green)
                        .brightness(-0.2) // front leg is slightly lighter
                        .frame(width: width * 0.2, height: height * 0.5)
                        .rotationEffect(.degrees(bounce ? -15 : 15), anchor: .top)
                        .offset(x: width * (bounce ? 0.6 : 0.2), y: height * (bounce ? backLeg : frontLeg))

                    // body
                    Path { path in
                        // curved head
                        let topRadius = width/2
                        let center: CGPoint = .init(x: topRadius, y: topRadius)
                        let angle: CGFloat = 30
                        let headBottomY = center.y + topRadius * sin(angle * .pi/180)

                        path.addArc(
                            center: center,
                            radius: topRadius,
                            startAngle: .degrees(180 - angle),
                            endAngle: .degrees(angle),
                            clockwise: false
                        )

                        // close the head shape
                        path.addLine(to: .init(
                            x: center.x - topRadius * cos(angle * .pi/180),
                            y: headBottomY
                        ))
                        path.closeSubpath()
                    }
                    .fill(Color.green, style: .init(eoFill: true))
                    .brightness(-0.2)

                    // eyes
                    HStack {
                        Ellipse()
                            .fill(Color.brown).brightness(-0.2)
                            .frame(width: width * 0.2, height: width * 0.3)
                        Spacer()
                        Ellipse()
                            .fill(Color.brown).brightness(-0.2)
                            .frame(width: width * 0.2, height: width * 0.3)
                    }
                    .frame(width: width * 0.6, height: width * 0.3)
                    .mask {
                        VStack(spacing: 0) {
                            Color.clear
                            Color.white // only the bottom is visible
                        }
                    }
                    .offset(x: width * 0.2, y: width * 0.2)
                }
                .compositingGroup() // apply shadow onto whole view
                .shadow(radius: 5)
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
                .shadow(radius: 5)
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
    VStack {
        ZStack(alignment: .topLeading) {
            GroundTileView(tile: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .dirt))
            PlayerView(player: .init(frame: .init(x: 20, y: 20, width: 60, height: 60), variant: .ghost))
        }
        ZStack(alignment: .topLeading) {
            GroundTileView(tile: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .dirt))
            PlayerView(player: .init(frame: .init(x: 20, y: 20, width: 60, height: 60), variant: .zombie))
        }
    }
    .padding(10)
}
