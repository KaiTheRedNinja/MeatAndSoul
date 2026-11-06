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
        SpriteRender(sprite: moveable) { rect, _ in
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
                WoodenBridge(
                    rect: rect,
                    intactness: moveable.isOpen ? 1 : 0,
                    isLeftToRight: [SpriteOrientation.left, .right].contains(moveable.orientation)
                )
            }
        }
    }
}

@Animatable
struct WoodenBridge: View {
    @AnimatableIgnored let rect: CGRect
    var intactness: CGFloat // between 0 (broken) and 1 (not broken)
    @AnimatableIgnored let isLeftToRight: Bool

    private var width: CGFloat { rect.width }
    private var height: CGFloat { rect.height }

    private var plankCount: Int { 7 }

    var body: some View {
        ZStack {
            let widthFactor = isLeftToRight ? 1 : 0.55
            let heightFactor = isLeftToRight ? 0.55 : 1

            bridgePlanks(broken: true)
                .frame(width: width * widthFactor, height: height * heightFactor)
                .rotationEffect(.degrees(25 * (intactness - 1)))
        }
        .animation(.bouncy(duration: 0.3, extraBounce: 0.2), value: intactness)
        .frame(width: width, height: height)
    }

    // planks
    private func bridgePlanks(broken: Bool) -> some View {
        GeometryReader { geo in
            ZStack {
                // Outer wooden frame
                RoundedRectangle(cornerRadius: min(width, height) * 0.04)
                    .fill(Color(red: 0.30, green: 0.17, blue: 0.08))
                    .opacity(intactness)

                let layout: AnyLayout = isLeftToRight
                    ? AnyLayout(HStackLayout(spacing: 1))
                    : AnyLayout(VStackLayout(spacing: 1))

                layout {
                    ForEach(0..<plankCount, id: \.self) { index in
                        plank
                            .rotationEffect(.radians(
                                (intactness - 1) * sin(CGFloat(index) * 5)
                            ))
                            // for broken tiles we skip every other tile
                            .opacity(max(CGFloat((index+1)%2), intactness))
                    }
                }
                .padding((isLeftToRight ? geo.size.width : geo.size.height) * 0.025)
            }
        }
    }

    private var plank: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.65, green: 0.42, blue: 0.22),
                        Color(red: 0.45, green: 0.27, blue: 0.13)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .stroke(Color.black.opacity(0.2), lineWidth: 1)
    }
}

#Preview {
    ZStack(alignment: .topLeading) {
        // ichor
        ObstacleView(
            obstacle: .init(
                frame: .init(x: 20, y: 0, width: 60, height: 200),
                variant: .ichor,
                orientation: .up,
                joints: []
            )
        )
        // crossable bridge
        MoveableView(
            moveable: .init(
                linked: "A",
                frame: .init(x: 0, y: 0, width: 100, height: 100),
                variant: .bridge,
                orientation: .left,
                defaultClosed: true,
                isOpen: true
            )
        )
        // blocked bridge
        MoveableView(
            moveable: .init(
                linked: "A",
                frame: .init(x: 0, y: 100, width: 100, height: 100),
                variant: .bridge,
                orientation: .left,
                defaultClosed: true,
                isOpen: false
            )
        )

        // wall
        ObstacleView(
            obstacle: .init(
                frame: .init(x: 120, y: 0, width: 60, height: 200),
                variant: .wall,
                orientation: .up,
                joints: []
            )
        )
        // open gate
        MoveableView(
            moveable: .init(
                linked: "A",
                frame: .init(x: 100, y: 0, width: 100, height: 100),
                variant: .door,
                orientation: .left,
                defaultClosed: true,
                isOpen: true
            )
        )
        // closed gate
        MoveableView(
            moveable: .init(
                linked: "A",
                frame: .init(x: 100, y: 100, width: 100, height: 100),
                variant: .door,
                orientation: .left,
                defaultClosed: true,
                isOpen: false
            )
        )
    }
    .border(Color.cyan)
    .frame(width: 200, height: 200, alignment: .topLeading)
    .padding(50)
}
