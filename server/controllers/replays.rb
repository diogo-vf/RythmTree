require_relative "../models/replay"
require_relative "../models/dbElement"
class ReplaysController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def get_all
        DBElement.array_to_hash Replay.find_all
    end
end