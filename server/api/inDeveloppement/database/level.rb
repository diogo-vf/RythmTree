class Level < DBElement
    def initialize
        @collection_name = "levels"
        @attributes = {
            id: String,
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