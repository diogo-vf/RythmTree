class UsersController
    @@instance = nil

    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def register_user data, connection
        puts "register for user #{data["name"]}"
        return {
            :name => data["name"]
        }
    end
end