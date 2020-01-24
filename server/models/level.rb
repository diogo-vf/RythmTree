require_relative "dbElement"
require_relative "sequence"
require_relative "texture"
require_relative "music"
require_relative "player"

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
            creator: Player
        }
        super
    end
end