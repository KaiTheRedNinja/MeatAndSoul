import SwiftUI

import SwiftUI
import AppKit

// make the window zoom shown
struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            guard let window = nsView.window,
                  !window.isZoomed else {
                return
            }

            window.zoom(nil)
        }
    }
}

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .dark)
                .navigationTitle("Meat+Soul")
                .background(WindowAccessor())
        }
    }
}
