class SequenceItem < DBElement
    def initialize
        @attributes = {
            key: String, 
            time: Fixnum,
            duration: Fixnum 
        }
        super
    end
end

