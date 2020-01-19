
class Sequence < DBElement
    attributes = {
        id: MongoID,
        sequence_item_array: SequenceItemArray,
        players: PlayerArray
    }
end

