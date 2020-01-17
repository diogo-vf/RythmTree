class BasicAPI

    public

    def initialize(collection_name, action, data, dataToReplace)
        return [] unless collection_name &&  collection_name.is_a?(String)
        return [] unless action &&  action.is_a?(String)
        return [] unless data &&  data.is_a?(Hash) 
        return [] unless dataToReplace && dataToReplace.is_a?(Hash)
       
        puts MongoDB = MongoDB.new
        @collection_name = collection_name
        @action = action
        @data = data
    end

    private
    def choiceAction
        case @action         
        when "getAll"
            getAll
        when "getOne"
            getOne
        when "InsertOne"
            insertOne
        when "updateOne"
            updateOne
        when "updateMany"
            updateMany
        when "deleteOne"
            deleteOne
        when "deleteMany"
            deleteMany
        else
            return []
        end
        
    end

        # TODO       
    def getAll 
        @collection.find( @data ).each do |value| 
            puts value     
        end 
    end

    def getOne        
        result = collection.find( @data ).first
    end

    def insertOne
        collection.insert_one( @data )
    end

    def updateOne
        collection.find_one_and_replace( @data, "$set" => @dataToReplace )
    end

    def updateMany
        collection.update_many( @data, "$set" => @dataToReplace )
    end

    def deleteOne
        collection.delete_one( @data )
    end

    def deleteMany
        collection.delete_many( @data )
    end
end