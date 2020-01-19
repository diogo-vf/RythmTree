require "json"
require "#{__dir__}/database/dbElement"
require "#{__dir__}/database/mongoID"
require "#{__dir__}/database/creator"
require "#{__dir__}/database/texture"
require "#{__dir__}/database/music"
require "#{__dir__}/database/player"
require "#{__dir__}/database/playerArray"
require "#{__dir__}/database/sequenceItem"
require "#{__dir__}/database/sequenceItemArray"
require "#{__dir__}/database/sequence"
require "#{__dir__}/database/sequenceArray"
require "#{__dir__}/database/level"
require "#{__dir__}/database/replay"

class Test < DBElement
    
    def initialize
        @attributes = { a: "bonjout"}
    end
end

b = Player.new
#b.attributes = {b: "sdsds"}


# faire une méthode find statique qui va récup des données dans la db par rapport à l'id
# et créé un objet en fonction de la collection et ne met que les données dispo