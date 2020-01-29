require_relative "../models/sequence"
require_relative "../models/sequenceItem"
require_relative "../models/dbElement"
class SequencesController
    @@instance = nil
    public
    def self.inst
        return @@instance if @@instance
        @@instance = self.new
    end

    def find id
        Sequence.find id
    end

    def insert hash
        raise "#{self.class} variable not a hash" unless hash.is_a? Hash
        # TODO  remove when game insert sequences
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
        sequence.player = hash[:player]
        sequence.save

        sequence.id
    end
end