class SequenceArray < DBArray      
    def initialize(value=nil)
        @contentClass = SequenceItem
    end
end