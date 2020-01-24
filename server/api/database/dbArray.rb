require_relative "dbElement"

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