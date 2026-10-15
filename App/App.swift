import SwiftUI

@main
struct StageWriterApp: App {
    var body: some Scene {
        WindowGroup("StageWriter", id: "welcome") {
            WelcomeView()
        }
        .windowResizability(.contentSize)
        .defaultLaunchBehavior(.presented)
        
        DocumentGroup { document in
            EditorView(state: EditorState(document: document))
        } makeDocument: { configuration, context in
            StagePlayDocument()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultLaunchBehavior(.suppressed)
        .commands {
            StageWriterCommands()
        }
    }
}

struct StageWriterCommands: Commands {
    @Environment(\.openDocument) private var openDocument

    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("New") {
                Task {
                    await NewFileService.createNewFile(open: openDocument)
                }
            }
            .keyboardShortcut("n", modifiers: .command)
        }
    }
}
