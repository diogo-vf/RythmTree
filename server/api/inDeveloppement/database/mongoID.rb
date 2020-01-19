class MongoID < DBElement
    def initialize(value=nil)
        @id = BSON::ObjectId.from_string( value )
    end
end