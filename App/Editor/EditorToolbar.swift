import SwiftUI
import Engine

struct EditorToolbar: View {
    @Bindable var state: EditorState

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(state.document.play.title ?? "Untitled")
                    .lineLimit(1)
                    .italic(state.document.play.title == nil)
                    .bold()
                    .focusable(false)
                
                Spacer()

                HStack(spacing: 14) {
                    ForEach(EditorMode.allCases) { mode in
                        Button(mode.title) { state.mode = mode }
                            .buttonStyle(.plain)
                            .foregroundStyle(state.mode == mode ? .primary : .secondary)
                            .bold(state.mode == mode)
                    }
                }
            }
            .frame(height: 32)
            .frame(maxWidth: .infinity)
            .padding(.leading, 80)
            .padding(.trailing, 15)
            
            Divider()
        }
    }
}
