require_relative "../models/texture"
require_relative "../models/dbElement"
class TexturesController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def find_all
        DBElement.array_to_hash Texture.find_all
    end
    def find hash
        raise "#{self.class} variable not a hash" unless hash.is_a? Hash
        Texture.find hash
    end

    def create hash
        raise "#{self.class} variable not a hash" unless hash.is_a? Hash
        texture = Texture.new
        texture.tree = hash[:tree]
        texture.platform = hash[:platform]

        texture
    end
end