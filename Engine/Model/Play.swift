import Foundation

public struct Play: Codable, Identifiable {
    public var id: UUID
    
    public var created: Date
    public var modified: Date
    
    public var title: String?
    public var author: String?
    
    public var acts: [Act]
    public var characters: [Character]
    
    var scriptFile: String
    var charactersFile: String
    
    public init() {
        self.id = UUID()
        
        self.created = .now
        self.modified = .now
        
        self.acts = []
        self.characters = []
        
        self.scriptFile = "script.xml"
        self.charactersFile = "characters.xml"
    }
}
