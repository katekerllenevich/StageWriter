import Foundation
import XMLCoder

struct XMLManifest: Codable, Identifiable, DynamicNodeEncoding {
    var id = UUID()
    var version: Int = StageplayArchive.VERSION
    
    var dates = Dates()
    struct Dates: Codable {
        var created: Date = .now
        var modified: Date = .now
    }
    
    var document = Document()
    struct Document: Codable {
        var title: String?
        var author: String?
        
        var paths = Paths()
        struct Paths: Codable {
            var characters: String = ""
            var script: String = ""
        }
    }
    
    // Determines how files are encoded
    enum CodingKeys: String, CodingKey {
        case id, version, dates, document
    }

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.version:
            return .attribute
        default:
            return .element
        }
    }
}
