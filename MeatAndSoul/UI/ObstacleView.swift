//
//  ObstacleView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 5/11/26.
//

import SwiftUI
import Combine

struct ObstacleView: View {
    var obstacle: Obstacle

    @Environment(\.currentOffset) var timeOffset: TimeInterval

    var body: some View {
        SpriteRender(sprite: obstacle) {
            rect,
            _ in

            switch obstacle.variant {
            case .wall:
                // im really not trying here....
                Color(white: 0.3)
                    .rockyMask(
                        padding: -5,
                        amplitude: 10,
                        factor: 1/7,
                        rect: rect
                    )
                    .background {
                        Rectangle()
                            .fill(Color.black)
                            .blur(radius: 10)
                    }
            case .ichor:
                let padding: CGFloat = 7 // how far outside bounds the lines go, on average
                let amplitude: CGFloat = 3 // how large the zigzagging is
                let factor: CGFloat = 1/5 // how rough lines are

                let outerEdge = padding + amplitude
                let bigRect = CGRect(
                    x: rect.minX - outerEdge,
                    y: rect.minY - outerEdge,
                    width: rect.width + 2*outerEdge,
                    height: rect.height + 2*outerEdge
                )

                ZStack {
                    Color.blue
                    VStack(spacing: 0) {
                        let startYIndex = Int(bigRect.minY / 10)
                        let endYIndex = Int(bigRect.maxY / 10)
                        ForEach(startYIndex..<endYIndex, id: \.self) { yIndex in
                            Color.purple
                                .opacity(
                                    0.8 + 0.2*sin(CGFloat(yIndex) * 0.3 + timeOffset)
                                )
                        }
                    }

                    Color.black
                        .reverseMask {
                            Rectangle()
                                .padding(.leading, obstacle.joints.contains(.left) ? -15 : 0)
                                .padding(.trailing, obstacle.joints.contains(.right) ? -15 : 0)
                                .padding(.top, obstacle.joints.contains(.up) ? -15 : 0)
                                .padding(.bottom, obstacle.joints.contains(.down) ? -15 : 0)
                                .blur(radius: 10)
                        }
                }
                .compositingGroup()
                .waterMask(padding: padding, amplitude: amplitude, factor: factor, phase: timeOffset, rect: rect, joints: obstacle.joints)
            case .salt:
                Color(white: 0.8)
            case .lava:
                let padding: CGFloat = 3 // how far outside bounds the lines go, on average
                let amplitude: CGFloat = 3 // how large the zigzagging is
                let factor: CGFloat = 1/3 // how rough lines are

                let outerEdge = padding + amplitude
                let bigRect = CGRect(
                    x: rect.minX - outerEdge,
                    y: rect.minY - outerEdge,
                    width: rect.width + 2*outerEdge,
                    height: rect.height + 2*outerEdge
                )

                ZStack {
                    Color.red
                    HStack(spacing: 0) {
                        let startXIndex = Int(bigRect.minX / 10)
                        let endXIndex = Int(bigRect.maxX / 10)
                        ForEach(startXIndex..<endXIndex, id: \.self) { xIndex in
                            Color.orange
                                .opacity(
                                    0.6 + 0.2*sin(CGFloat(xIndex) * 0.3 - timeOffset)
                                )
                        }
                    }

                    Color.black
                        .reverseMask {
                            Rectangle()
                                .padding(.leading, obstacle.joints.contains(.left) ? -15 : 0)
                                .padding(.trailing, obstacle.joints.contains(.right) ? -15 : 0)
                                .padding(.top, obstacle.joints.contains(.up) ? -15 : 0)
                                .padding(.bottom, obstacle.joints.contains(.down) ? -15 : 0)
                                .blur(radius: 10)
                        }
                }
                .compositingGroup()
                .waterMask(padding: padding, amplitude: amplitude, factor: factor, phase: -timeOffset, rect: rect, joints: obstacle.joints)
            }
        }
    }
}

extension View {
    func rockyMask(
        padding: CGFloat,
        amplitude: CGFloat,
        factor: CGFloat,
        rect: CGRect
    ) -> some View {
        let outerEdge = padding + amplitude

        let step: CGFloat = 5 // one sample every 5

        return self
            .padding(-outerEdge)
            .mask {
                Path { path in
                    path.move(to: .init(
                        x: min(0, amplitude * sin((rect.minY - outerEdge) * factor) - padding),
                        y: -outerEdge
                    ))
                    // left barrier
                    for point in stride(from: -outerEdge, through: rect.height + outerEdge, by: step) {
                        let absoluteYOffset = CGFloat(point) + rect.minY
                        path.addLine(to: .init(
                            x: min(0, amplitude * sin(absoluteYOffset * factor) - padding),
                            y: CGFloat(point))
                        )
                    }
                    // right barrier
                    for point in stride(from: -outerEdge, through: rect.height + outerEdge, by: step).reversed() {
                        let absoluteYOffset = CGFloat(point) + rect.minY
                        path.addLine(to: .init(
                            x: rect.width + max(0, amplitude * sin(absoluteYOffset * factor) + padding),
                            y: CGFloat(point))
                        )
                    }
                    path.closeSubpath()
                }
                .fill(Color.black)
            }
            .mask {
                Path { path in
                    path.move(to: .init(
                        x: -outerEdge,
                        y: min(0, amplitude * sin((rect.minX - outerEdge) * factor) - padding)
                    ))
                    // top barrier
                    for point in stride(from: -outerEdge, through: rect.width + outerEdge, by: step) {
                        let absoluteXOffset = CGFloat(point) + rect.minX
                        path.addLine(to: .init(
                            x: CGFloat(point),
                            y: min(0, amplitude * sin(absoluteXOffset * factor) - padding)
                        ))
                    }
                    // bottom barrier
                    for point in stride(from: -outerEdge, through: rect.width + outerEdge, by: step).reversed() {
                        let absoluteXOffset = CGFloat(point) + rect.minX
                        path.addLine(to: .init(
                            x: CGFloat(point),
                            y: rect.height + max(0, amplitude * sin(absoluteXOffset * factor) + padding)
                        ))
                    }
                    path.closeSubpath()
                }
                .fill(Color.black)
            }
    }

    func waterMask(
        padding: CGFloat,
        amplitude: CGFloat,
        factor: CGFloat,
        phase: CGFloat,
        rect: CGRect,
        joints: Set<SpriteOrientation>
    ) -> some View {
        let outerEdge = padding + amplitude

        let step: CGFloat = 5 // one sample every 5

        return self
            .padding(-outerEdge)
            .mask {
                Path { path in
                    // left barrier
                    if joints.contains(.left) {
                        path.move(to: .init(
                            x: -padding,
                            y: -outerEdge
                        ))
                        path.addLine(to: .init(
                            x: -padding,
                            y: rect.height + outerEdge
                        ))
                    } else {
                        path.move(to: .init(
                            x: amplitude * sin((rect.minY - outerEdge) * factor + phase) - padding,
                            y: -outerEdge
                        ))
                        for point in stride(from: -outerEdge, through: rect.height + outerEdge, by: step) {
                            let absoluteYOffset = CGFloat(point) + rect.minY
                            path.addLine(to: .init(
                                x: amplitude * sin(absoluteYOffset * factor + phase) - padding,
                                y: CGFloat(point))
                            )
                        }
                    }
                    // right barrier
                    if joints.contains(.right) {
                        path.addLine(to: .init(
                            x: rect.width + padding,
                            y: rect.height + outerEdge
                        ))
                        path.addLine(to: .init(
                            x: rect.width + padding,
                            y: -outerEdge
                        ))
                    } else {
                        for point in stride(from: -outerEdge, through: rect.height + outerEdge, by: step).reversed() {
                            let absoluteYOffset = CGFloat(point) + rect.minY
                            path.addLine(to: .init(
                                x: rect.width + amplitude * sin(absoluteYOffset * factor + phase) + padding,
                                y: CGFloat(point))
                            )
                        }
                    }
                    path.closeSubpath()
                }
                .fill(Color.black)
            }
            .mask {
                Path { path in
                    // top barrier
                    if joints.contains(.up) {
                        path.move(to: .init(
                            x: -outerEdge,
                            y: -padding
                        ))
                        path.addLine(to: .init(
                            x: rect.width + outerEdge,
                            y: -padding
                        ))
                    } else {
                        path.move(to: .init(
                            x: -outerEdge,
                            y: amplitude * sin((rect.minX - outerEdge) * factor + phase) - padding
                        ))
                        for point in stride(from: -outerEdge, through: rect.width + outerEdge, by: step) {
                            let absoluteXOffset = CGFloat(point) + rect.minX
                            path.addLine(to: .init(
                                x: CGFloat(point),
                                y: amplitude * sin(absoluteXOffset * factor + phase) - padding
                            ))
                        }
                    }
                    // bottom barrier
                    if joints.contains(.down) {
                        path.addLine(to: .init(
                            x: rect.width + outerEdge,
                            y: rect.height + padding
                        ))
                        path.addLine(to: .init(
                            x: -outerEdge,
                            y: rect.height + padding
                        ))
                    } else {
                        for point in stride(from: -outerEdge, through: rect.width + outerEdge, by: step).reversed() {
                            let absoluteXOffset = CGFloat(point) + rect.minX
                            path.addLine(to: .init(
                                x: CGFloat(point),
                                y: rect.height + amplitude * sin(absoluteXOffset * factor + phase) + padding
                            ))
                        }
                    }
                    path.closeSubpath()
                }
                .fill(Color.black)
            }
    }
}
