require_relative "../models/level"
require_relative "../models/dbElement"
class LevelsController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def find_all
        DBElement.array_to_hash Level.find_all
    end
    def find_first
        Level.find_all.first
    end
    def find id
        Level.find id 
    end

    def insert hash
        raise "#{self.class} variable not a hash" unless hash.is_a? Hash
        level = Level.new
        level.name = hash[:name]
        level.difficulty = hash[:difficulty]
        level.hardcore = hash[:hardcore]
        level.music = hash[:music]
        level.texture = hash[:texture]
        level.sequence = hash[:sequence]
        level.creator = hash[:creator]
        level.save

        level.id
    end
end