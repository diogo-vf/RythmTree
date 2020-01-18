require "json"

class DBElement
    attr_accessor :attributes

    def initialize

    end
end

class Test < DBElement
    
    def initialize
        @attributes = { a: "bonjout"}
    end
end

b = Test.new
#b.attributes = {b: "sdsds"}

puts b.attributes
