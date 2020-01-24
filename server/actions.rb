require_relative "controllers/users"
require_relative "controllers/levels"
class WSActions
    public
    def self.on_ws_action(connection, action, data)
        case action
            when "register"
                UsersController.inst.register_user data, connection 
            when "getLevels"
                LevelsController.inst.get_all
        end
    end
end