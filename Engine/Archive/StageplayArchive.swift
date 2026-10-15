import Foundation
import XMLCoder
import ZIPFoundation

public enum StageplayArchive {
    public static let VERSION = 1

    private static func makeEncoder() -> XMLEncoder {
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    private static func makeDecoder() -> XMLDecoder {
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    public static func read(_ data: Data) throws -> Play {
        let archive = try Archive(data: data, accessMode: .read)
        let decoder = makeDecoder()
        
        let manifestData = try archive.readFile(path: "manifest.xml")
        let manifest = try decoder.decode(XMLManifest.self, from: manifestData)
        
        let charactersData = try archive.readFile(path: manifest.document.paths.characters)
        let characters = try decoder.decode(XMLCharacters.self, from: charactersData)
        
        return ArchiveConverter.toPlay(data: (manifest, characters))
    }
    
    public static func getMetadata(_ data: Data) -> (String?, String?, Date)? {
        do {
            let archive = try Archive(data: data, accessMode: .read)
            
            let manifestData = try archive.readFile(path: "manifest.xml")
            let manifest = try makeDecoder().decode(XMLManifest.self, from: manifestData)
            
            return (manifest.document.title, manifest.document.author, manifest.dates.modified)
        } catch {
            return nil
        }
    }
    
    // TODO: proper error handling if data cannot be created
    public static func write(_ play: Play) throws -> Data {
        let archive = try Archive(accessMode: .create)
        let encoder = makeEncoder()
        
        let (manifest, characters) = ArchiveConverter.fromPlay(play)
        
        // manifest.xml
        let manifestData = try encoder.encode(
            manifest,
            withRootKey: "stageplay",
            header: XMLHeader(version: 1.1, encoding: "UTF-8")
        )
        try archive.writeFile(data: manifestData, path: "manifest.xml")
        
        // characters.xml
        let charactersData = try encoder.encode(
            characters,
            withRootKey: "characters",
            header: XMLHeader(version: 1.1, encoding: "UTF-8")
        )
        try archive.writeFile(data: charactersData, path: manifest.document.paths.characters)
        
        return archive.data!
    }
}

extension Archive {
    func readFile(path: String) throws -> Data {
        guard let entry = self[path] else {
            throw ArchiveError.invalidEntryPath
        }
        
        var data = Data()
        let _ = try self.extract(entry) { chunk in
            data.append(chunk)
        }
        
        return data
    }
    
    func writeFile(data: Data, path: String) throws {
        try self.addEntry(
            with: path,
            type: .file,
            uncompressedSize: Int64(data.count),
            compressionMethod: .deflate,
            provider: { position, size in
                return data.subdata(in: Data.Index(position)..<Int(position)+size)
            }
        )
    }
}
