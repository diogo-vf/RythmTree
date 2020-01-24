############################################
#  CREATE Level                            #
############################################

player = Player.new
player.name = "carlo"
player.character = "Galactic_squid"
player.save

music = Music.new
music.name = "Credits Roll"
music.duration = 206060
music.src = "songs/music1.mp3"
music.bpm = 106
music.start_offset = 537
music.save

sequenceItem1 = SequenceItem.new
sequenceItem1.key = "a"
sequenceItem1.time = 2000
sequenceItem1.duration = 120

sequenceItem2 = SequenceItem.new
sequenceItem2.key = "f"
sequenceItem2.time = 4000
sequenceItem2.duration = 120

sequence = Sequence.new
sequence.sequences.push sequenceItem1
sequence.sequences.push sequenceItem2
sequence.player = player
sequence.save

texture = Texture.new
texture.tree = "Turtle_tree"
texture.platform = "DoguiDogui_platform"

level = Level.new
level.name = "Rapteur"
level.difficulty = "easy"
level.hardcore = 0
level.music = music
level.sequence = sequence
level.texture = texture
level.creator = player
level.save

idLevel = level.id

############################################
#  GET Level                               #
############################################

level2 = Level.find idLevel

############################################
#  UPDATE Level                            #
############################################
level2.name="Raptor"


level2.save

############################################
#  UPDATE Level                            #
############################################

level2.delete