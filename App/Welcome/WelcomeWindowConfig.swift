import SwiftUI
import AppKit

struct WelcomeWindowConfig: View {
    
    var body: some View {
        WindowConfigurator { window in
            // Fully remove titlebar
            window.styleMask.insert(.fullSizeContentView)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.titlebarSeparatorStyle = .none

            // Drag the window from any empty background area
            window.isMovableByWindowBackground = true

            // Prevent resizing & set to content size
            window.styleMask.remove(.resizable)

            // Remove minimize and fullscreen capability
            window.styleMask.remove(.miniaturizable)
            window.collectionBehavior.remove(.fullScreenPrimary)

            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
        }
    }
}
