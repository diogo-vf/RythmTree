require_relative "dbArray"
require_relative "player"

class PlayerArray < DBArray
    def initialize
        @contentClass=Player
    end
end