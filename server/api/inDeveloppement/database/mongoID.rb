class MongoID < DBElement
    def initialize(value = nil)
        
        if value
            id=BSON::ObjectId.from_string( value.to_s )
        else
            id=""
        end

        @attributes = {
            id: id
        }

        super
    end
end