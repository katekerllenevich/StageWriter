import SwiftUI
import UniformTypeIdentifiers
import Engine

@Observable
class StagePlayDocument: Document {
    static var readableContentTypes = [UTType.stagePlay]
    
    typealias Reader = FileWrapperDocumentReader<Play>
    typealias Writer = FileWrapperDocumentWriter<Play>
    
    var play: Play
    init(play: Play = Play()) {
        self.play = play
    }

    func edit(_ mutate: (inout Play) -> Void) {
        mutate(&play)
        play.modified = .now
    }

    @MainActor
    func apply(snapshot: sending Play, previous: sending Play?) async throws {
        play = snapshot
    }
    
    @MainActor
    func snapshot(contentType: UTType) async throws -> sending Play {
        play
    }
    
    func reader(configuration: sending ReadConfiguration) -> sending FileWrapperDocumentReader<Play> {
        FileWrapperDocumentReader(configuration) { fileWrapper in
            guard let data = fileWrapper.regularFileContents else {
                throw CocoaError(.fileReadCorruptFile)
            }
            
            return try StageplayArchive.read(data)
        }
    }
    
    func writer(configuration: sending WriteConfiguration) -> sending FileWrapperDocumentWriter<Play> {
        FileWrapperDocumentWriter(configuration) { play, _ in
            let data = try StageplayArchive.write(play)
            
            return FileWrapper(regularFileWithContents: data)
        }
    }
}
