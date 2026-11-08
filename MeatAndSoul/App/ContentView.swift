import SwiftUI
import Playgrounds

struct ContentView: View {
    @State var page: Page = .home

    var body: some View {
        content
            .background {
                // ghost icons
                GeometryReader { geom in
                    VStack {
                        Spacer()
                        ForEach(0..<Int(geom.size.height / 100 + 1), id: \.self) { rowNo in
                            HStack {
                                Spacer()

                                ForEach(0..<Int(geom.size.width / 100 + 1), id: \.self) { _ in
                                    let choice = ["👻", "🪦", "🧟", "🎃"].randomElement()!
                                    Text(choice)
                                        .opacity(0.5)

                                    Spacer()
                                }
                            }
                            .offset(x: CGFloat(rowNo%2) * 50)
                            Spacer()
                        }
                    }
                }
                .padding(-100)
            }
    }

    @ViewBuilder
    var content: some View {
        switch page {
        case .home:
            HomeView(onLevelPressed: {
                print("Level pressed!")
                page = .levelSelect
            }, onStart: {
                print("Started!")
                page = .level(0)
            })
        case .level(let index):
            GameView(
                manager: .init(level: allLevels[index]),
                onLevelPressed: {
                    print("Level pressed!")
                    page = .levelSelect
                }, onFinish: {
                    print("Level finished!")
                    if index + 1 < allLevels.count {
                        page = .level(index + 1)
                    } else {
                        page = .noMoreLevels
                    }
                }
            )
            .id(index)
        case .noMoreLevels:
            EndView(onLevelPressed: {
                print("Level pressed!")
                page = .levelSelect
            }, onRestart: {
                print("Started!")
                page = .home
            })
        case .levelSelect:
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Text("Level Select")
                        .font(.system(size: 70, design: .serif))
                        .minimumScaleFactor(0.5)

                    Spacer()
                }

                Spacer()

                HStack(spacing: 30) {
                    Button {
                        page = .home
                    } label: {
                        Image(systemName: "house")
                            .font(.system(size: 50, design: .serif))
                            .padding(30)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.purple)
                                    .saturation(0.3)
                            }
                    }
                    .buttonStyle(.plain)

                    ForEach(0..<allLevels.count, id: \.self) { index in
                        Button {
                            page = .level(index)
                        } label: {
                            Text("\(index)")
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
                }

                Spacer()
            }
        }
    }
}

enum Page {
    case home
    case level(Int)
    case noMoreLevels
    case levelSelect
}

#Preview {
    ContentView()
}
