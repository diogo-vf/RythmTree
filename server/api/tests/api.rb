require "json"

class DBElement
    def initialize(data = false)
        @attributes_data = {}
        #   attributes est le truc dans les class de notre db
        #
        #   foreach attributes as indAttr => attrValue
        #       @attributeData[indAttr] = attrValue.new
        #       create getters/setters 
        #   end

        return unless data
        add_data data
    end
    public def add_data(data)
        # assign data from data array
        data.keys.each {|key|
            next unless attributeData[key] 
            if attributeData[key].is_a? DBElementFundamental
                attributeData[key].value = data[key]
                next
            end
            attributeData[key].add_data data[key]
        }
    end

    public def to_val_hash()
        hash = {};
        @attributes_data.keys.each{ |key|
            hash[key] = @attributes_data[key].to_val_hash
        }
        hash
    end
    public def to_json
        to_val_hash.to_json
    end
    public def save()
        puts "save success"
    end
    #static
    def self.from_id(id)
        puts id
        data = {} #get data from db 
        self.new data; #return instance
    end

end

class DBElementFundamental
    #attr_accessor :value
    def initialize(val = nil)
        @value = val
    end
    def value
        @value
    end
    def value= (newVal)
        @value = newVal
    end
    public def to_val_hash #not really a hash for special cases
        @value
    end
end
#special cases
class DBString < DBElementFundamental

end
class DBBoolean < DBElementFundamental

end
class DBInteger < DBElementFundamental
    
end
class DBArray < DBElementFundamental
    def initialize (givenVal)
        super givenVal
    end
    # def value= (newVal)
    #     array = []
    #     newVal.each { |classData|
    #         array.push @contentClass.new classData
    #     }
    #     array
    # end
    def set_value (index, newVal)
        @value[index] = newVal
    end
    def get_value (index)
        @value[index]
    end
    def to_val_hash
        array = [];
        @value.each {|component|
            array.push component.to_val_hash
        }
        array
    end
end













class Replay < DBElement
    # module Replay
    #     module Level
    #         ID
    #         NAME
    #         DIFFICULTY
    #         HARDCORE
    #         module Music
    #             ID
    #             NAME
    #             DURATION
    #         end
    #         module Creator
    #             ID
    #             Name    
    #         end
    #     end
    #     module Players
    #       module Player
    #         ID
    #         NAME
    #         CHARACTER
    #       end    
    #     end
    # end
end


moninstancemoche = Level.from_id "jgdj";
moninstancemoche.save
puts "-------------------------------------"
# moninstancemoche.data="lol3"
# puts moninstancemoche.data
puts "-------------------------------------"
puts moninstancemoche.to_json
puts "-------------------------------------"
puts moninstancemoche.instance_variables 