import SwiftUI
import AppKit

struct EditorWindowConfig: View {
    
    var body: some View {
        WindowConfigurator { window in
            // Disable titlebar
            window.styleMask.insert(.fullSizeContentView)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true

            // Disable system toolbar
            window.toolbar = nil
        }
    }
}
