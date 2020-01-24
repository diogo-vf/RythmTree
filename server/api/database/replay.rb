require_relative "dbElement"
require_relative "sequenceArray"
require_relative "level"

class Replay < DBElement
    def initialize
        @collection_name = "replays"
        @attributes = {
            id: String,
            level: Level,
            sequences: SequenceArray
        }
        super
    end
end