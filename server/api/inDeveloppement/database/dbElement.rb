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
                    raise "Sorry my friend, it's not the right class... I expect #{expected_class}, your class is a #{val.class}" unless val.class == expected_class
                    @attributes_data[attr] = val 
                } 
                if attr == :id
                    define_singleton_method("#{attr}=") { |val| 
                        raise "Sorry my friend, it's not the right class... I expect #{expected_class}, your class is a #{val.class}" unless val.class == expected_class
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
            else
                hash[key.to_sym] = value
            end
        }
        
        hash
    end

    public 

    def find id
        "un id"
    end

    def save
        raise "object #{self.class} not saveable" unless @collection_name
        puts "saving #{self} into #{@collection_name} collection
        --------------------------------"
        to_hash   
    end

end

class DBArray < Array    
    def push value
        raise "Sorry, but isn't the right class! I expect a #{@contentClass}, your class is a #{value.class}" unless value.is_a? @contentClass
        super value
    end
    
    def []= index, value
        raise "Sorry, but isn't the right class! I expect a #{@contentClass}, your class is a #{value.class}" unless value.is_a? @contentClass
        super index, value 
    end

    def to_hash
        {
            xd: "lol"
        }
    end
end
