//
//  InteractableView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 5/11/26.
//

import SwiftUI

struct InteractableView: View {
    var interactable: Interactable

    var body: some View {
        SpriteRender(sprite: interactable) { rect, _ in
            let size = rect.width

            switch interactable.variant {
            case .button:
                ButtonView(color: interactable.linked.color, isPressed: interactable.active ? 1 : -1, size: size)
            case .lever:
                LeverView(color: interactable.linked.color, isOn: interactable.active ? 1 : -1, size: size)
            }
        }
    }
}

@Animatable
struct ButtonView: View {
    @AnimatableIgnored var color: Color
    var isPressed: CGFloat // between -1 (off) and 1 (on)
    var size: CGFloat

    var body: some View {
        // button!
        ZStack {
            // base
            Circle()
                .fill(Color(red: 0.35, green: 0.03, blue: 0.03))
                .offset(y: size * 0.08)

            // surface
            Circle()
                .fill(color)
                .overlay {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isPressed > 0
                                ? [
                                    Color(red: 0.65, green: 0.05, blue: 0.05),
                                    Color(red: 0.45, green: 0.02, blue: 0.02)
                                ]
                                : [
                                    Color(red: 1.0, green: 0.18, blue: 0.15),
                                    Color(red: 0.72, green: 0.03, blue: 0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(0.2)
                }
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: size * 0.025)
                        .opacity(0.2)
                }
                .shadow(
                    color: .black.opacity(0.275 + isPressed * -0.125), // 0.15 when on, 0.4 when off
                    radius: 0.04 * size
                )
                .offset(y: size * ((isPressed + 1) / 2) * 0.06) // 0.06 when on, 0 when off
                .padding(10)
        }
        .animation(.bouncy(duration: 0.3, extraBounce: 0.2), value: isPressed)
        .frame(width: size, height: size)
    }
}

@Animatable
struct LeverView: View {
    @AnimatableIgnored var color: Color
    var isOn: CGFloat // between -1 (off) and 1 (on)
    var size: CGFloat

    var body: some View {
        // switch
        ZStack {
            // housing and channel
            Capsule()
                .fill(color)
                .overlay {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(white: 0.32),
                                    Color(white: 0.45),
                                    Color(white: 0.28)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(0.2)
                }
                .padding(-30)
                .frame(width: size * 0.22, height: size * 0.65)
            Capsule()
                .fill(Color.black.opacity(0.6))
                .frame(width: size * 0.22, height: size * 0.65)

            // stem
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(white: 0.85),
                            Color(white: 0.45),
                            Color(white: 0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.48, height: size * 0.13)
                .offset(x: size * -0.16)
                .rotationEffect(.degrees(isOn * 65))

            // handle
            Capsule()
                .fill(
                    LinearGradient(
                        colors: isOn > 0
                        ? [.red, Color(red: 0.65, green: 0.02, blue: 0.02)]
                        : [Color(white: 0.8), Color(white: 0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.22, height: size * 0.3)
                .overlay {
                    Capsule()
                        .stroke(Color.white.opacity(0.25), lineWidth: size * 0.015)
                }
                .shadow(color: .black.opacity(0.5), radius: size * 0.04, y: size * 0.03)
                .offset(x: size * -0.30)
                .rotationEffect(.degrees(isOn * 65))

            // fulcrum
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(white: 0.8),
                            Color(white: 0.35),
                            Color(white: 0.1)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.15
                    )
                )
                .frame(width: size * 0.24, height: size * 0.24)
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: size * 0.015)
                }
        }
        .animation(.bouncy(duration: 0.3, extraBounce: 0.2), value: isOn)
        .frame(width: size, height: size)
    }
}
