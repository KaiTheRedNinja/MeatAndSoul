import SwiftUI
import Playgrounds

struct ContentView: View {
    @State var page: Page = .home

    var body: some View {
        switch page {
        case .home:
            HomeView()
        case .level(let index):
            GameView(manager: .init(level: allLevels[index]))
        }
    }
}

enum Page {
    case home
    case level(Int)
}

#Preview {
    ContentView()
}
