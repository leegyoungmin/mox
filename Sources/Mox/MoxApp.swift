import SwiftUI

@main
struct MoxApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(minWidth: 860, minHeight: 580)
        }
        .windowStyle(.titleBar)
    }
}
