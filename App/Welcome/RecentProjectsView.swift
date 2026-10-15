import SwiftUI
import Engine

struct RecentProject: Identifiable {
    let url: URL
    let title: String?
    let author: String?
    let modified: Date
    
    var id: URL { url }
    
    /// Relative for the last week ("5 minutes ago"), absolute date after that.
    var modifiedDisplay: String {
        if Date.now.timeIntervalSince(modified) < 7 * 24 * 3600 {
            Self.relativeFormatter.localizedString(for: modified, relativeTo: .now)
        } else {
            modified.formatted(date: .abbreviated, time: .shortened)
        }
    }
    
    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()
    
    static func loadRecents() async -> [RecentProject] {
        let urls = NSDocumentController.shared.recentDocumentURLs
        
        return await Task.detached(priority: .userInitiated) {
            urls.compactMap { url in
                guard let data = try? Data(contentsOf: url),
                      let metadata = StageplayArchive.getMetadata(data) else {
                    return nil
                }
                
                return RecentProject(url: url, title: metadata.0, author: metadata.1, modified: metadata.2)
            }
        }.value
    }
}

struct RecentProjectsView: View {
    let projects: [RecentProject]
    let onOpen: (URL) -> Void
    
    var body: some View {
        if projects.isEmpty {
            Spacer()
        } else {
            VStack(alignment: .leading) {
                Text("Recently Opened:")
                    .font(.caption)
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(projects) { project in
                            RecentProjectRow(project: project) {
                                onOpen(project.url)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RecentProjectRow: View {
    let project: RecentProject
    let onOpen: () -> Void
    
    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: 12) {
                Image(systemName: "text.document")
                    .font(.title)
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading) {
                    Text(project.title ?? "Untitled")
                        .italic(project.title == nil)
                        .font(.title3)
                        .lineLimit(1)
                    
                    Text(project.author ?? "No Author")
                        .italic(project.author == nil)
                        .font(.subheadline)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(project.modifiedDisplay)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
}
