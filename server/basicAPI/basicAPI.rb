require "json"

class BasicAPI
    
    public

    def self.connection        
        mongo = MongoDB.new
    end

    def self.actions( mongo, hash )    
        sort_data hash 
        return [{ error: "action not a string" }] unless @action.is_a?( String )
        return [{ error: "collection_name not a string" }] unless @collection_name.is_a?( String )
        return [{ error: "data not a hash" }] unless @data.is_a?( Hash ) 

        #select table
        mongo.collection = @collection_name
        @mongo = mongo

        @action = action_type( @action,@data[:_id] )

        choose_action 
    end

    private

    def self.sort_data hash        
        @action = hash[:action]
        @collection_name = hash[:collection_name]
        @data = hash[:data]  

        #replace _id string to bson object
        @data[:_id] = BSON::ObjectId.from_string( @data[:_id] ) if @data[:_id]
    end

    def self.action_type(action,id = nil)
        unless id then
            type = "_many"
        else
            type = "_one"
        end
        
        #example add_get
        action += type
    end

    def self.choose_action
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

    def self.get_one   
        result=@mongo.collection.find( @data ).first
        result[:error] = "Success"  
        result[:_id] = result[:_id].to_s  

        [ result ]        
    end

    def self.get_many 
        array=[]
        @mongo.collection.find( @data ).each do |result| 
            result[:error] = "Success"  
            result[:_id] = result[:_id].to_s  
            array.push( result )
        end 

        array
    end

    def self.insert_one
        @mongo.collection.insert_one( @data )

        [{ error: "Success" }]
    end

    def self.update_one
        @mongo.collection.find_one_and_replace( @data, "$set" => @dataToReplace )

        [{ error: "Success" }]
    end

    def self.update_many
        @mongo.collection.update_many( @data, "$set" => @dataToReplace )

        [{ error: "Success" }]
    end

    def self.delete_one
        @mongo.collection.delete_one( @data )

        [{ error: "Success" }]
    end

    def self.delete_many
        @mongo.collection.delete_many( @data )

        [{ error: "Success" }]
    end
end