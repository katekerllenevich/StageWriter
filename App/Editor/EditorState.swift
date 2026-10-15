import SwiftUI

@Observable
class EditorState {
    var document: StagePlayDocument
    var mode: EditorMode = .script
    
    init(document: StagePlayDocument) {
        self.document = document
    }
}

enum EditorMode: String, CaseIterable, Identifiable {
    case script
    case cast
    case typeset

    var id: Self {
        self
    }

    var title: String {
        rawValue.capitalized
    }
}
