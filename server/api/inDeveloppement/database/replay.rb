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