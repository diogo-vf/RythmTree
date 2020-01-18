
class Sequence < DBElement
    attributes = {
        :id => MongoID,
        :level => Level,
        :creator => Creator,
        :players => PlayerArray,
        :sequence_array => SequenceArray
    }
end

