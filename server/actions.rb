require_relative "controllers/users"
class WSActions
    public
    def self.on_ws_action(connection, action, data)
        case action
            when "register"
                UsersController.inst.register_user data, connection 
        end
    end

    private

end