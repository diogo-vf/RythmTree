class PlayerArray < DBArray
    def initialize (value=nil)
        @contentClass = Player
        super value(value)
    end
end