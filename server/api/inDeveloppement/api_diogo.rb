require "json"
require "mongo"
require "pp"

require_relative "../mongoDB"
require_relative "../../config/config"
require_relative "database/dbElement"
require_relative "database/creator"
require_relative "database/texture"
require_relative "database/music"
require_relative "database/player"
require_relative "database/sequenceItem"
require_relative "database/sequenceItemArray"
require_relative "database/sequence"
require_relative "database/sequenceArray"
require_relative "database/level"
require_relative "database/replay"

#  player = Player.new
# music = Music.new
# sequence = Sequence.new
# replay = Replay.new

level = Level.new
level.id="5e2704eb6e95525bbc2b1f7b";
level.name="Nicoal le charbon"
level.music.name="bondour"
level.texture.tree="arbre a fleurs"
level.creator.name="sdasd"

pp level

# a = SequenceItem.new # zone danger pour le to_hash
# a.key="a"
# a.time=5546
# a.duration=120
# level.sequence.sequences.push a
# level.creator.name="sdasd"
# a = SequenceItem.new # zone danger pour le to_hash
# a.key="a"
# a.time=5546
# a.duration=120
# level.sequence.sequences.push a
# level.creator.name="sdasd"
# a = SequenceItem.new # zone danger pour le to_hash
# a.key="a"
# a.time=5546
# a.duration=120
# level.sequence.sequences.push a
# level.creator.name="sdasd"
# a = SequenceItem.new # zone danger pour le to_hash
# a.key="a"
# a.time=5546
# a.duration=120
# level.sequence.sequences.push a
# a = SequenceItem.new # zone danger pour le to_hash
# a.key="a"
# a.time=5546
# a.duration=120
# level.sequence.sequences.push a

# # level.sequence
# level.sequence.player.name="lol"

pp Level.find("5e2704eb6e95525bbc2b1f7b")

# pp level.save

# pp level.delete


# faire une méthode find statique qui va récup des données dans la db par rapport à l'id
# et créé un objet en fonction de la collection et ne met que les données dispo