require_relative "dbElement"
require_relative "player"
require_relative "sequenceItemArray"

class Sequence < DBElement
    def initialize
        @collection_name = "sequences"
        @attributes = {
            id: String,
            sequences: SequenceItemArray,
            player: Player
        }
        super
    end
end