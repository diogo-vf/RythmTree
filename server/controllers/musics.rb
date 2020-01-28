require_relative "../models/music"
require_relative "../models/dbElement"
class MusicsController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def get_all
        DBElement.array_to_hash Music.find_all
    end
end