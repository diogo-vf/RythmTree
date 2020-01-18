class Level < DBElement
    attributes = {
        :id => MongoID,
        :name => DBString,
        :difficulty => DBString,
        :hardcore => DBBoolean
        :music => Music,
        :sequence => Sequence,
        :texture => Texture,
        :creator => Creator
    }
end