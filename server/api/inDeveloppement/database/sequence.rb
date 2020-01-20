class Sequence < DBElement
    def initialize
        @collection_name = "sequence"
        @attributes = {
            id: String,
            sequences: SequenceItemArray,
            player: Player
        }
        super
    end
end

