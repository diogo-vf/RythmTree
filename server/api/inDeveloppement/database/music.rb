class Music < DBElement
    def initialize
        @collection_name = "musics"
        @attributes = {
            id: String,
            name: String,
            duration: Fixnum,
            src: String,
            bpm: Fixnum,
            start_offset: Fixnum
        }
        super
    end
end