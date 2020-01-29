require_relative "dbArray"
require_relative "sequence"

class SequenceArray < DBArray
    def initialize
        @contentClass=Sequence
    end
end