class DBElement
    def initialize(data = nil)
        @attributes_data = {}
        create_accessors @attributes        
    end
    def create_accessors ( attributes = {} )
        attributes.each do |attr, expected_class|

            if expected_class.class == Class && ( expected_class < DBElement || expected_class < DBArray )
                @attributes_data[attr] = expected_class.new
            else
                # Setter
                define_singleton_method("#{attr}=") { |val|                     
                    raise "#{self.class}.#{attr}=#{ val } | Sorry, it's not the right class... I expect #{expected_class}, your class is a #{val.class}" unless val.class == expected_class
                    @attributes_data[attr] = val 
                } 
                if attr == :id
                    define_singleton_method("#{attr}=") { |val| 
                        raise "#{self.class}.#{attr}=#{val } | Sorry, it's not the right class... I expect #{expected_class}, your class is a #{val.class}" unless val.class == expected_class
                        begin
                            val = BSON::ObjectId.from_string(val)
                        rescue => exception
                            raise "Your id isn't an id of mongo exemple -> '5e2198f66e955215e787420f'"
                        end
                        
                        @attributes_data[attr] = val 
                    } 
                end                   
            end

            # Getter
            define_singleton_method(attr) { @attributes_data[attr] }            
        end
    end

    # create an hash of our object
    def to_hash
        hash={}
        @attributes_data.each { |key, value|

            if @attributes[key.to_sym] < DBElement || @attributes[key.to_sym] < DBArray               
                hash[key.to_sym] = value.to_hash  
                next
            end          
            hash[key.to_sym] = value
        }        
        hash
    end
    def to_json
        to_hash.to_json
    end

    public
    # hash_to_convert -> hash get by mongoDB
    def apply_hash_data(hash_to_convert)
        hash_to_convert.each{ |key, value|
            if key == "_id"
                @attributes_data[:id]=value 
                next
            end

            if value.is_a?(Hash) || value.is_a?(Array)
                @attributes_data[key.to_sym].apply_hash_data(value)
                next
            end
            @attributes_data[key.to_sym] = value
        }
    end

    def refresh_data
        # get information of object
        hash = to_hash

        mongo = MongoDB.new
        mongo.collection = @collection_name
        
        collection = mongo.collection.find( {_id: hash[:id]} ).first 
        
        raise "#{self.class} object without data" if collection.to_s == ""

        clean_collection = bson_doc_to_hash collection
        apply_hash_data(clean_collection)  
    end

    def self.find id        
        obj = self.new
        obj.id = id
        
        obj.refresh_data    

        obj
    end


    def save
        raise "object #{self.class} not saveable" unless @collection_name
        puts "\nsaving #{self} into #{@collection_name} collection\n\n"
        
        hash = to_hash
        
        mongo = MongoDB.new
        mongo.collection = @collection_name.to_sym
        unless hash[:id]
            puts "#{self.class} added"
            mongo.collection.insert_one(hash) 
        else
            id=hash[:id]
            hash.delete(:id)
            puts "#{self.class} updated"
            mongo.collection.update_one({_id: id}, "$set" => hash)
        end   
    end

    def delete         
        mongo = MongoDB.new
        mongo.collection = @collection_name.to_sym
        mongo.collection.delete_one({_id: @attributes_data[:id]})
    end

end

class DBArray < Array    
    def initialize
    end

    def push value
        raise "Sorry, but isn't the right class! I expect a #{@contentClass}, your class is a #{value.class}" unless value.is_a? @contentClass
        super value
    end
    
    def []= index, value
        raise "Sorry, but isn't the right class! I expect a #{@contentClass}, your class is a #{value.class}" unless value.is_a? @contentClass
        super index, value 
    end

    def apply_hash_data array
        clear
        array.each{ | value |
            if value.is_a?(Hash) || value.is_a?(Array)
                item = @contentClass.new
                item.apply_hash_data(value)
                push item
                next
            end
            push value
        }
    end

    def each
        super
    end

    def to_hash
        map{|val| val.to_hash}
    end
    def to_json
        to_hash.to_json
    end
end



def bson_doc_to_hash bson_doc
    hash = {}
    bson_doc.each{ |key, val|
        if val.is_a? BSON::Document
            hash[key.to_sym] = bson_doc_to_hash val
        elsif val.is_a? Array
            hash[key.to_sym] = bson_doc_to_array val
        else
            hash[key.to_sym] = val
        end
    }
    
    hash
end
def bson_doc_to_array bson_array
    array = []
    bson_array.each{ |val|
        if val.is_a? BSON::Document
            array.push bson_doc_to_hash val
        elsif val.is_a? Array
            array.push bson_doc_to_array val
        else
            array.push val
        end
    }

    array
end