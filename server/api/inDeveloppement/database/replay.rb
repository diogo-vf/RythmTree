class Replay < DBElement
    attributes = {
        id: MongoID,
        level: Level,
        sequences: SequenceArray
    }
end