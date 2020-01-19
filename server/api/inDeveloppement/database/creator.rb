class Creator < DBElement
    def initialize
        @attributes = {
            id: MongoID,
            name: String
        }
        super
    end
end