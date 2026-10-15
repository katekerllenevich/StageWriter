import SwiftUI

struct WelcomeView: View {
    @Environment(\.openDocument) private var openDocument
    @Environment(\.dismiss) private var dismiss
    
    @State private var recents: [RecentProject] = []
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("StageWriter")
                    .font(.largeTitle)
                Text("© 2026 Kate Kerllenevich")
                    .font(.footnote)
                
                HStack {
                    Button("New script") {
                        Task {
                            if await NewFileService.createNewFile(open: openDocument) {
                                dismiss()
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                    Button("Open script") {
                        Task {
                            await openExistingFile()
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .frame(height: 150, alignment: .bottom)
            
            RecentProjectsView(projects: recents) { url in
                Task {
                    await openFile(at: url)
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 20)
            .frame(maxHeight: .infinity, alignment: .top)
            .task {
                recents = await RecentProject.loadRecents()
            }
        }
        .frame(width: 400, height: 550)
        .background(WelcomeWindowConfig())
    }
    
    @MainActor
    private func openExistingFile() async {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.stagePlay]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        guard let window = NSApp.keyWindow else {
            return
        }
        
        let response = await panel.beginSheetModal(for: window)
        guard response == .OK, let url = panel.url else {
            return
        }
        
        await openFile(at: url)
    }
    
    @MainActor
    private func openFile(at url: URL) async {
        do {
            try await openDocument(at: url)
            dismiss()
        } catch {
            // TODO handle error opening file
        }
    }
}

