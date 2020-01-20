require "json"
require "mongo"
require "#{__dir__}/database/dbElement"
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

level = Level.new
# player = Player.new
# music = Music.new
# sequence = Sequence.new
# replay = Replay.new

puts "---------Add data to object-------------"

level.music.name="bondour"
level.texture.tree="arbre a fleurs"
level.creator.name="sdasd"
a = SequenceItem.new
a.key="a"
level.sequence.sequences.push a

puts "----------It's Show TIME------------"

require "pp"
level.id="5e2198f66e955215e787420f"
pp level.id

pp level.save


# faire une méthode find statique qui va récup des données dans la db par rapport à l'id
# et créé un objet en fonction de la collection et ne met que les données dispo