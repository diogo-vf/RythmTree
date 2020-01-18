class Music < DBElement
    attributes = {
        :id => MongoID,
        :name => DBString,
        :duration => DBInteger,
        :src => DBString,
        :bpm => DBInteger,
        :start_offset => DBInteger
    }
end