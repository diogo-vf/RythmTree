class Sequence < DBElement
    def initialize
        @collection_name = "sequence"
        @attributes = {
            id: String,
            sequences: SequenceItemArray,
            players: PlayerArray
        }
        super
    end
end

