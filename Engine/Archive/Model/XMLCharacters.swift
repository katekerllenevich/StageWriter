
import Foundation

struct XMLCharacters: Codable {
    var characters: [Character] = []
    struct Character: Codable, Identifiable {
        var id = UUID()
        var name: String = ""
        var alias: String?
        var bio: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case characters = "character"
    }
}
