import Foundation

public struct Character: Codable, Identifiable {
    public var id = UUID()
    
    public var name: String
    public var alias: String?
    public var bio: String?
    
    init(name: String, alias: String?, bio: String?) {
        self.name = name
        self.alias = alias
        self.bio = bio
    }
}
