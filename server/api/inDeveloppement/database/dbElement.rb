class DBElement
    attr_accessor :attributes

    def initialize
        puts attributes
    end

    def find id
        puts "lol"
    end
end
#special cases
class DBElementFundamental
    #attr_accessor :value
    def initialize(val = nil)
        @value = val
    end
end
class DBString < DBElementFundamental

end
class DBBoolean < DBElementFundamental

end
class DBInteger < DBElementFundamental
    
end
class DBArray < DBElementFundamental

end