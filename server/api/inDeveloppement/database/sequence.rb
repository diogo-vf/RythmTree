
class Sequence < DBElement
    def initialize
        @attributes = {
            id: MongoID,
            sequence_item_array: SequenceItemArray,
            players: PlayerArray
        }
        super
    end
end

