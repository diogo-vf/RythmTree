class UsersController
    @@instance = nil
    
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def register_user data, connection
        "ok boomer"
    end
end