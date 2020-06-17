require "mongo" unless NO_DB
require "json"
require_relative "mongoDB" unless NO_DB
require_relative "dbArray"

class DBElement
    def initialize(data = nil)
        @attributes_data = {}
        create_accessors @attributes        
    end

    def create_accessors ( attributes = {} )
        attributes.each do |attr, expected_class|

            if expected_class.class == Class && ( expected_class < DBElement || expected_class < DBArray )
                @attributes_data[attr] = expected_class.new
            end

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
            
            # Getter
            define_singleton_method(attr) { @attributes_data[attr] }            
            define_singleton_method(attr) { @attributes_data[attr].to_s } if attr == :id
        end
    end

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
        to_hash().to_json()
    end

    public
    # hash_to_convert -> hash get by mongoDB
    def apply_hash_data(hash_to_convert)
        hash_to_convert.each{ |key, value|
            if key == :_id
                @attributes_data[:id]=value.to_s
                next
            end

            if value.is_a?(Hash) || value.is_a?(Array)
                @attributes_data[key.to_sym].apply_hash_data(value)
                next
            end
            @attributes_data[key.to_sym] = value
        }
    end

    def self.find id 
        obj = self.new    
        data = {}
        data[:_id] = BSON::ObjectId.from_string(id)
        obj.refresh_data(data).first
    rescue => exception
        raise "Your id isn't an id of mongo example -> '5e2198f66e955215e787420f', Exception #{exception}"
    end

    def self.find_all    
        obj = self.new

        obj.refresh_data
    end
    
    def self.where hash
        raise "Where method require an hash" unless hash.is_a? Hash

        obj = self.new

        array = obj.refresh_data hash
        return array.first if array.length == 1
        array
    end

    def refresh_data data = nil
        # get information of object
        hash = to_hash
        
        mongo = MongoDB.new
        mongo.collection = @collection_name
        collections = []
        mongo.collection.find( data ).each { |collection|
            obj = self.class.new

            clean_collection = Utils.bson_doc_to_hash collection
            obj.apply_hash_data(clean_collection) 
            collections.push obj
        } 

        collections    
    end
    
    def save
        raise "object #{self.class} not saveable" unless @collection_name
        
        hash = to_hash
        
        mongo = MongoDB.new
        mongo.collection = @collection_name.to_sym
        unless hash[:id]            
            result = mongo.collection.insert_one(hash)

            self.id = result.inserted_id.to_s
        else
            id=hash[:id]
            hash.delete(:id)
            
            mongo.collection.update_one({_id: id}, "$set" => hash)
        end   
    end

    def delete         
        mongo = MongoDB.new
        mongo.collection = @collection_name.to_sym
        mongo.collection.delete_one({_id: @attributes_data[:id]})
    end

    def self.array_to_hash array
        array.map{|val| val.to_hash}
    end
end