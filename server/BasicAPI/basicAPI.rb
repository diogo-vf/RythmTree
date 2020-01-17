require "json"
class BasicAPI

    public
    def initialize(collection_name, action, data, dataToReplace = nil)
        puts collection_name
        puts action
        puts data
        
        
        return [] unless collection_name.is_a?(String)
        return [] unless action.is_a?(String)
        return [] unless data.is_a?(Hash) 

        if dataToReplace.is_a?(Hash) then
            @dataToReplace = dataToReplace
        elsif dataToReplace then
            return [] 
        end

        @mongo = MongoDB.new
        @mongo.collection=collection_name

        @action = action
        @data = data

       puts choice_action
    end

    private
    def choice_action
        case @action         
        when "get_many"
            get_many
        when "get_one"
            get_one
        when "insert_one"
            insert_one
        when "update_one"
            update_one
        when "update_many"
            update_many
        when "delete_one"
            delete_one
        when "delete_many"
            delete_many
        else
            return []
        end
        
    end

    def get_one        
        [ @mongo.collection.find( @data ).first.to_json ]
    end

    def get_many 
        array=[]
        @mongo.collection.find( @data ).each do |value| 
            array.push value.to_json     
        end 

        array
    end

    def insert_one
        @mongo.collection.insert_one( @data )
    end

    def update_one
        @mongo.collection.find_one_and_replace( @data, "$set" => @dataToReplace )
    end

    def update_many
        @mongo.collection.update_many( @data, "$set" => @dataToReplace )
    end

    def delete_one
        @mongo.collection.delete_one( @data )
    end

    def delete_many
        @mongo.collection.delete_many( @data )
    end
end