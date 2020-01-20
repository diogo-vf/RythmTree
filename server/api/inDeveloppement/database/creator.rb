class Creator < DBElement
    def initialize
        @attributes = {
            id: String,
            name: String
        }
        super
    end
end