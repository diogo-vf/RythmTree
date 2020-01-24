require_relative "../models/level"
require_relative "../models/dbElement"
class LevelsController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def get_all
        DBElement.array_to_hash Level.find_all
    end
end