require_relative "controllers/users"
require_relative "controllers/levels"
require_relative "controllers/players"
class WSActions
    public
    def self.on_ws_action(connection, action, data)
        case action
            when "register"
                UsersController.inst.register_user data, connection 
            when "getLevels"
                LevelsController.inst.get_all
            when "createPlayer"
                PlayersController.inst.insert ""
                PlayersController.inst.get_all.to_json
        end
    end
end