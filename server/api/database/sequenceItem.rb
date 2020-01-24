require_relative "dbElement"

class SequenceItem < DBElement
    def initialize
        @attributes = {
            key: String, 
            time: Integer,
            duration: Integer 
        }
        super
    end
end