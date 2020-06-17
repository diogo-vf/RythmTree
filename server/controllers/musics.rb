require_relative "../models/music"
require_relative "../models/dbElement"
class MusicsController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def find_all
        DBElement.array_to_hash Music.find_all
    end
    def find_first
        Music.find_all.first
    end
    
    def find id
        Music.find id
    end

    def insert hash
        raise "#{self.class} variable not a hash" unless hash.is_a? Hash
        music = Music.new
        music.name = hash[:name]
        music.duration = hash[:duration]
        music.src = hash[:src]
        music.bpm = hash[:bpm]
        music.start_offset = hash[:start_offset]
        music.save

        music.id
    end
end