require_relative "../models/player"
require_relative "../models/dbElement"
class PlayersController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end
    def initialize
        @logged_users = {}
    end

    def find_all
        DBElement.array_to_hash Player.find_all
    end
    
    def find hash
        raise "#{self.class} variable not a hash" unless hash.is_a? Hash
        Player.find hash
    end
    def find_first
        Player.find_all.first
    end

    def insert name
        player = Player.new
        player.name = name
        player.save

        player.id
    end
    def register_user data, connection  
        player = Player.find({name: data["name"]})

        unless player
            id = insert(data["name"])
            player = Player.find({name: data["name"]})
        end 

        #add to logged
        

        player
    end
end