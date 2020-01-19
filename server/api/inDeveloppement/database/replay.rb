class Replay < DBElement
    def initialize
        @attributes = {
            id: MongoID,
            level: Level,
            sequences: SequenceArray
        }
        super
    end
end