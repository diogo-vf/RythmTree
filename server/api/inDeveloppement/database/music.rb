class Music < DBElement
    def initialize
        @attributes = {
            id: MongoID,
            name: String,
            duration: Integer,
            src: String,
            bpm: Integer,
            start_offset: Integer
        }
        super
    end
end