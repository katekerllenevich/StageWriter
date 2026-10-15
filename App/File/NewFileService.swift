import SwiftUI
import Engine

enum NewFileService {
    
    @MainActor
    static func createNewFile(open: OpenDocumentAction) async -> Bool {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.stagePlay]
        panel.allowsOtherFileTypes = false
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.nameFieldStringValue = "Untitled.stageplay"
        
        let response: NSApplication.ModalResponse
        if let window = NSApp.keyWindow {
            response = await panel.beginSheetModal(for: window)
        } else {
            response = await panel.begin()
        }
        guard response == .OK, var url = panel.url else {
            return false
        }

        if url.pathExtension.lowercased() != "stageplay" {
            url.appendPathExtension("stageplay")
        }

        do {
            try StageplayArchive.write(Play()).write(to: url, options: .atomic)
            try await open(at: url)
            return true
        } catch {
            // TODO handle error creating file
            return false
        }
    }
}
