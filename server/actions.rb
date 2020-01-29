require_relative "controllers/users"
require_relative "controllers/levels"
require_relative "controllers/players"
require_relative "controllers/musics"
require_relative "controllers/textures"
require_relative "controllers/sequences"
require "pp"
class WSActions
    public
    def self.on_ws_action(connection, action, data)
        case action
            when "register"
                UsersController.inst.register_user data, connection 
            when "createPlayer"
                last_id = PlayersController.inst.insert data["name"]
                result = PlayersController.inst.find(last_id).to_json

                "User Added: #{result}"
            when "getPlayers"
                result = PlayersController.inst.find_all.to_json
                "#{result}"
            when "getFirstPlayer"
                PlayersController.inst.find_first.id
            when "getMusics"
                MusicsController.inst.find_all.to_json
            when "createMusic"
                hash = {
                    name: data["name"],
                    duration: data["duration"].to_i, 
                    src: data["src"], 
                    bpm: data["bpm"].to_i,
                    start_offset: data["start_offset"].to_i
                }                

                last_id = MusicsController.inst.insert hash
                result = MusicsController.inst.find(last_id).to_json
            when "getFirstMusic"
                MusicsController.inst.find_first.id
            when "insertLevel"
                textureHash = {tree: "arbre à fleurs", platform: "feuille standard"}
                texture = TexturesController.inst.create textureHash
                player = PlayersController.inst.find(data["creator"])
                sequenceHash = {player: player}
                last_seq = SequencesController.inst.insert sequenceHash
                hash = {
                    name: data["name"],
                    difficulty: data["difficulty"], 
                    hardcore: data["hardcore"].to_i, 
                    music: MusicsController.inst.find(data["musicID"]),
                    texture: texture,
                    creator: player,
                    sequence: SequencesController.inst.find(last_seq)
                }     

                last_level = LevelsController.inst.insert hash

                LevelsController.inst.find(last_level).to_json
            when "getLevels"
                LevelsController.inst.find_all.to_json
        end
    end
end