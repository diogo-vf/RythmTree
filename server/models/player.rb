require_relative "dbElement"

class Player < DBElement
    def initialize
        @collection_name = "players"
        @attributes = {
            id: String,
            name: String,
            character: String
        }
        super
    end
end