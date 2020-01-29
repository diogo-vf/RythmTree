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
            when "registerUser"
                PlayersController.inst.register_user(data, connection).to_hash
            when "createPlayer"
                last_id = PlayersController.inst.insert data["name"]
                PlayersController.inst.find({id: last_id}).to_hash
            when "getPlayers"
                PlayersController.inst.find_all
            when "getFirstPlayer"
                PlayersController.inst.find_first.id
            when "getMusics"
                MusicsController.inst.find_all
            when "createMusic"
                hash = {
                    name: data["name"],
                    duration: data["duration"].to_i, 
                    src: data["src"], 
                    bpm: data["bpm"].to_i,
                    start_offset: data["start_offset"].to_i
                }                

                last_id = MusicsController.inst.insert hash
                MusicsController.inst.find({id: last_id}).to_hash
            when "getFirstMusic"
                MusicsController.inst.find_first.id
            when "insertLevel"
                textureHash = {tree: "arbre à fleurs", platform: "feuille standard"}
                texture = TexturesController.inst.create textureHash
                player = PlayersController.inst.find({id: data["creator"]})
                sequenceHash = {player: player}
                sequence_id = SequencesController.inst.insert sequenceHash
                hash = {
                    name: data["name"],
                    difficulty: data["difficulty"], 
                    hardcore: data["hardcore"].to_i, 
                    music: MusicsController.inst.find({id: data["musicID"]}),
                    texture: texture,
                    creator: player,
                    sequence: SequencesController.inst.find({id: sequence_id})
                }     

                last_id = LevelsController.inst.insert hash
                LevelsController.inst.find({id: last_id}).to_hash
            when "getLevels"                
                LevelsController.inst.find_all
        end
    end
end