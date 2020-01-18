class Player < DBElement
    attributes = {
        :id => MongoID,
        :name => DBString,
        :character => DBString
    }
end