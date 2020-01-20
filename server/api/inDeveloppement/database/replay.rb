class Replay < DBElement
    def initialize
        @attributes = {
            id: String,
            level: Level,
            sequences: SequenceArray
        }
        super
    end
end