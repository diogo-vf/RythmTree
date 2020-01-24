require_relative "dbElement"

class Texture < DBElement
    def initialize
        @attributes = {
            tree: String,
            platform: String
        }
        super
    end
end