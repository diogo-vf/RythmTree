class Creator < DBElement
    attributes = {
        id: MongoID,
        name: DBString
    }
end