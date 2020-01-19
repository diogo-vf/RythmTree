class Player < DBElement
    def initialize
        @attributes = {
            id: MongoID,
            name: String,
            character: String
        }
        super
    end
end