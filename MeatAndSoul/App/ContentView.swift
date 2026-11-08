import SwiftUI
import Playgrounds

struct ContentView: View {
    @State var page: Page = .home

    var body: some View {
        switch page {
        case .home:
            HomeView(onLevelPressed: {
                print("Level pressed!")
            }, onStart: {
                print("Started!")
                page = .level(0)
            })
        case .level(let index):
            GameView(
                manager: .init(level: allLevels[index]),
                onLevelPressed: {
                    print("Level pressed!")
                }, onFinish: {
                    print("Level finished!")
                    if index + 1 < allLevels.count {
                        page = .level(index + 1)
                    } else {
                        page = .noMoreLevels
                    }
                }
            )
        case .noMoreLevels:
            EndView(onLevelPressed: {
                print("Level pressed!")
            }, onRestart: {
                print("Started!")
                page = .home
            })
        }
    }
}

enum Page {
    case home
    case level(Int)
    case noMoreLevels
}

#Preview {
    ContentView()
}
