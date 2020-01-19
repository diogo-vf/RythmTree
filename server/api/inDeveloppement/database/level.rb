class Level < DBElement
    attributes = {
        id: MongoID,
        name: DBString,
        difficulty: DBString,
        hardcore: DBInteger,
        music: Music,
        sequence: Sequence,
        texture: Texture,
        creator: Creator
    }
end