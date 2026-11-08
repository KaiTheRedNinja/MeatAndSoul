//
//  HomeView.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 8/11/26.
//

import SwiftUI

struct HomeView: View {
    @State var manager: LevelManager = .init(
        level: .init(
            name: "Meat+Soul",
            replacements: [
                "A": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .text(.init(text: "This is Meat")))),
                "B": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .text(.init(text: "This is Soul")))),
                "C": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .text(.init(text: "Have them meet, then escape the graveyard!")))),

                "V": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 60, height: 60), variant: .playerMimic(.zombie))),
                "W": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 50, height: 50), variant: .text(.init(text: "+", backgroundColor: .clear, textColor: .black)))),
                "X": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 60, height: 60), variant: .playerMimic(.ghost))),
                "Y": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 50, height: 50), variant: .text(.init(text: "~>", backgroundColor: .clear, textColor: .black)))),
                "Q": .init(decoration: .init(frame: .init(x: 0, y: 0, width: 60, height: 60), variant: .playerMimic(.human))),
            ],
            map: """
            .......
            .A B C.
            .VWXYQ.
            .......
            """
        )
    )

    var onLevelPressed: () -> Void
    var onStart: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()

                Text(manager.level.name)
                    .font(.system(size: 70, design: .serif))
                    .minimumScaleFactor(0.5)

                Spacer()
            }
            .overlay(alignment: .trailing) {
                Button {
                    onLevelPressed()
                } label: {
                    Text("Levels")
                        .font(.system(size: 20, design: .serif))
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(white: 0.25))
                        }
                }
                .buttonStyle(.plain)
            }

            Spacer()

            GeometryReader { proxy in
                let screenSize = manager.level.tiles.frame.size

                let scale = min(
                    proxy.size.width / screenSize.width,
                    proxy.size.height / screenSize.height,
                )

                ZStack(alignment: .center) {
                    LevelView(manager: manager)
                }
                .frame(width: screenSize.width, height: screenSize.height, alignment: .center)
                .clipped()
                .scaleEffect(.init(width: scale, height: scale), anchor: .center)
                .frame(width: proxy.size.width, height: proxy.size.height)
            }

            Button {
                onStart()
            } label: {
                Text("Start!")
                    .font(.system(size: 50, design: .serif))
                    .padding(30)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.purple)
                            .saturation(0.3)
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(50)
    }
}
