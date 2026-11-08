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
        let isLeftToRight: Bool = [SpriteOrientation.left, .right].contains(moveable.orientation)

        SpriteRender(sprite: moveable) { rect, _ in
            switch moveable.variant {
            case .door:
                MetalGate(
                    color: moveable.linked.color,
                    rect: rect,
                    openness: moveable.isOpen ? 1 : 0,
                    isLeftToRight: isLeftToRight
                )
            case .bridge:
                WoodenBridge(
                    color: moveable.linked.color,
                    rect: rect,
                    intactness: moveable.isOpen ? 1 : 0,
                    isLeftToRight: isLeftToRight
                )
            }
        }
    }
}

@Animatable
struct MetalGate: View {
    @AnimatableIgnored let color: Color
    @AnimatableIgnored let rect: CGRect
    var openness: CGFloat // 0 = closed, 1 = open
    @AnimatableIgnored let isLeftToRight: Bool

    private var w: CGFloat { rect.width }
    private var h: CGFloat { rect.height }

    private var thickness: CGFloat { min(w, h) * 0.22 }

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                gatePanel
                    .frame(width: thickness, height: h * 0.45)
                    .rotationEffect(.degrees(90 * openness), anchor: .topTrailing)
                    .offset(y: thickness * openness)
                    .overlay(alignment: .top) {
                        Circle() // hinge
                            .fill(Color(red: 0.149, green: 0.086, blue: 0.059))
                            .stroke(Color.black, lineWidth: 1)
                            .padding(3)
                            .brightness(0.1)
                    }

                Spacer()

                gatePanel
                    .frame(width: thickness, height: h * 0.45)
                    .rotationEffect(.degrees(-90 * openness), anchor: .bottomTrailing)
                    .offset(y: -thickness * openness)
                    .overlay(alignment: .bottom) {
                        Circle() // hinge
                            .fill(Color(red: 0.149, green: 0.086, blue: 0.059))
                            .stroke(Color.black, lineWidth: 1)
                            .padding(3)
                            .brightness(0.1)
                    }
            }

            Spacer()

            VStack(spacing: 0) {
                gatePanel
                    .frame(width: thickness, height: h * 0.45)
                    .rotationEffect(.degrees(-90 * openness), anchor: .topLeading)
                    .offset(y: thickness * openness)
                    .overlay(alignment: .top) {
                        Circle() // hinge
                            .fill(Color(red: 0.149, green: 0.086, blue: 0.059))
                            .stroke(Color.black, lineWidth: 1)
                            .padding(3)
                            .brightness(0.1)
                    }

                Spacer()

                gatePanel
                    .frame(width: thickness, height: h * 0.45)
                    .rotationEffect(.degrees(90 * openness), anchor: .bottomLeading)
                    .offset(y: -thickness * openness)
                    .overlay(alignment: .bottom) {
                        Circle() // hinge
                            .fill(Color(red: 0.149, green: 0.086, blue: 0.059))
                            .stroke(Color.black, lineWidth: 1)
                            .padding(3)
                            .brightness(0.1)
                    }
            }
        }
        .padding(.horizontal, w * 0.2)
        .frame(width: w, height: h, alignment: .center)
        .overlay {
            Text("🔒")
                .font(.system(size: min(w, h) * 0.3))
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.4))
                        .frame(width: min(w, h) * 0.5)
                )
                .opacity(1 - openness)
        }
        .animation(.bouncy(duration: 0.3, extraBounce: 0.2), value: openness)
    }

    // MARK: - Gate Panel

    private var gatePanel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .overlay {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(white: 0.55, opacity: 0.3),
                                    Color(white: 0.28, opacity: 0.3),
                                    Color(white: 0.42, opacity: 0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }

            // Metal bars
            GeometryReader { geo in
                ForEach(0..<4, id: \.self) { i in
                    Rectangle()
                        .fill(Color(white: 0.15))
                        .frame(width: geo.size.width * 0.07)
                        .position(
                            x: geo.size.width * CGFloat(i + 1) / 5,
                            y: geo.size.height / 2
                        )
                }
            }

            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
    }
}

@Animatable
struct WoodenBridge: View {
    @AnimatableIgnored let color: Color
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
            .fill(color)
            .stroke(Color.black, lineWidth: 1)
            .overlay {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(white: 0.55, opacity: 0.3),
                                Color(white: 0.28, opacity: 0.3),
                                Color(white: 0.42, opacity: 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
    }
}

#Preview {
    let testLink = LinkID(id: "test", color: .blue)

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
                linked: testLink,
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
                linked: testLink,
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
                linked: testLink,
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
                linked: testLink,
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
