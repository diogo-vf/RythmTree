class DBElement
    attr_accessor :attributes

    def initialize(data = nil)
        # puts @attributes
        create_accessors @attributes
    end

    def find id
        "un id"
    end

    def create_accessors ( attributes = {} )
        attributes.each do |attr, value|

            if value.class == Class && value < DBElement 
                attributes[attr] = value.new
            else                
                # Setter
                define_singleton_method("#{attr}=") { |val| attributes[attr] = val } 
            end

            # Getter
            define_singleton_method(attr) { attributes[attr] }
        end
    end

end

class DBArray
end