require_relative "dbArray"
require_relative "sequenceItem"

class SequenceItemArray < DBArray
    def initialize
        @contentClass=SequenceItem
    end
end