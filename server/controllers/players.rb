require_relative "../models/player"
require_relative "../models/dbElement"
class PlayersController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def get_all
        DBElement.array_to_hash Player.find_all
    end
end