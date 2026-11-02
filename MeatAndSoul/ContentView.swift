import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        SpriteRender(sprite: TestSprite(
            frame: .init(x: 0, y: 0, width: 400, height: 300),
            text: "Hello!"
        )) { _, sprite1 in
            Color.red

            Text(sprite1.text)

            SpriteRender(sprite: TestSprite(
                frame: .init(x: 10, y: 10, width: 200, height: 150),
                text: "Bye!"
            )) { _, sprite2 in
                Color.blue

                Text(sprite1.text)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct TestSprite: Sprite {
    var frame: CGRect
    var text: String
}
