class Player < DBElement
    def initialize
        @collection_name = "player"
        @attributes = {
            id: String,
            name: String,
            character: String
        }
        super
    end
end