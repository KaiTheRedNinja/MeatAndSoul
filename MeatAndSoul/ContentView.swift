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

#Playground {
    _ = 1 + 2
}

protocol Sprite {
    var frame: CGRect { get }
}

struct TestSprite: Sprite {
    var frame: CGRect
    var text: String
}

// render the sprite into the frame
struct SpriteRender<S: Sprite, V: View>: View {
    var sprite: S
    var content: (CGSize, S) -> V

    init(sprite: S, @ViewBuilder content: @escaping (CGSize, S) -> V) {
        self.sprite = sprite
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            content(sprite.frame.size, sprite)
        }
        .frame(width: sprite.frame.width, height: sprite.frame.height)
        .offset(x: sprite.frame.minX, y: sprite.frame.minY)
    }
}
