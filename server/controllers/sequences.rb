require_relative "../models/sequence"
require_relative "../models/dbElement"
class SequencesController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def find id
        DBElement.array_to_hash Sequence.find id
    end
end