require_relative "dbElement"

class Music < DBElement
    def initialize
        @collection_name = "musics"
        @attributes = {
            id: String,
            name: String,
            duration: Integer,
            src: String,
            bpm: Integer,
            start_offset: Integer
        }
        super
    end
end