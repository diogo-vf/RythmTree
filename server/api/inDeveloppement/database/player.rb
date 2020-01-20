class Player < DBElement
    def initialize
        @attributes = {
            id: String,
            name: String,
            character: String
        }
        super
    end
end