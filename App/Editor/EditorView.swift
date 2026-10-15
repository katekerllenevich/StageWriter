import SwiftUI
import Engine

struct EditorView: View {
    @State var state: EditorState

    var body: some View {
        VStack(spacing: 0) {
            EditorToolbar(state: state)

            Group {
                switch state.mode {
                case .script:
                    VStack {
                        Text("script")
                    }
                    
                case .cast:
                    CastPage(state: state)
                    
                case .typeset:
                    VStack {
                        Text("typeset")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 600, minHeight: 400)
        .ignoresSafeArea(.container, edges: .top)
        .background(EditorWindowConfig())
    }
}
