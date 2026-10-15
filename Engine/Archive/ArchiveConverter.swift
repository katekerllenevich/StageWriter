enum ArchiveConverter {
    static func fromPlay(_ play: Play) -> (XMLManifest, XMLCharacters) {
        var manifest = XMLManifest()
        manifest.id = play.id
        manifest.dates = XMLManifest.Dates(
            created: play.created,
            modified: play.modified
        )
        manifest.document = XMLManifest.Document(
            title: play.title,
            author: play.author,
            paths: XMLManifest.Document.Paths(
                characters: play.charactersFile,
                script: play.scriptFile
            )
        )
        
        var characters = XMLCharacters()
        characters.characters = play.characters.map { old in
            var new = XMLCharacters.Character()
            new.id = old.id
            new.name = old.name
            new.alias = old.alias
            new.bio = old.bio
            return new
        }
        
        return (manifest, characters)
    }
    
    static func toPlay(data: (XMLManifest, XMLCharacters)) -> Play {
        let (manifest, characters) = data
        
        var play = Play()
        play.id = manifest.id
        
        play.title = manifest.document.title
        play.author = manifest.document.author
        
        play.created = manifest.dates.created
        play.modified = manifest.dates.modified
        
        play.acts = []
        play.characters = characters.characters.map { old in
            var new = Character(
                name: old.name,
                alias: old.alias,
                bio: old.bio
            )
            new.id = old.id
            return new
        }
        
        play.scriptFile = manifest.document.paths.script
        play.charactersFile = manifest.document.paths.characters
        
        return play
    }
}
