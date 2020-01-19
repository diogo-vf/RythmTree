class Level < DBElement
    def initialize
        @attributes = {
            id: MongoID,
            name: String,
            difficulty: String,
            hardcore: Integer,
            music: Music,
            sequence: Sequence,
            texture: Texture,
            creator: Creator
        }
        super
    end
end