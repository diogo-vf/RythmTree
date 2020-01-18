require 'mongo'

Mongo::Logger.logger.level = ::Logger::ERROR
db_ip = "192.168.178.134"
db_port = 27017
db_name = "RythmTree"
client = Mongo::Client.new([ "#{db_ip}:#{db_port}" ], :database => db_name)

# Create Table
collection = client[:level]

## Insert
insert = collection.insert_one({
    "name": "niveau",
    "difficulty": "easy",
    "hardcore": "true",
    "music": {
        "id": 2,
        "name": "danse",
        "duration": 65411
    },
    "creator": {
        "id": 1,
        "name": "nicoal"
    },
})
id = insert.inserted_id.to_str # récupérer l'id généré par mongo

insert = collection.insert_many([{
    "id": 2,
    "name": "niveau",
    "difficulty": "easy",
    "hardcore": "true",
    "music": {
        "id": 2,
        "name": "danse",
        "duration": 65411
    },
    "creator": {
        "id": 1,
        "name": "nicoal"
    },
},
{
    "id": 1,
    "name": "niveau01",
    "difficulty": "hard",
    "hardcore": "false",
    "music": {
        "id": 1,
        "name": "danseNicoal",
        "duration": 65411
    },
    "creator": {
        "id": 1,
        "name": "a"
    },
},
{
    "id": 3,
    "name": "niveau02",
    "difficulty": "hard",
    "hardcore": "false",
    "music": {
        "id": 1,
        "name": "danseNicoal",
        "duration": 65411
    },
    "creator": {
        "id": 1,
        "name": "nulle"
    },
}])
nb_inserteds = insert.inserted_count

# select all levels with names "niveau01" 
collection.find({ name: "niveau01" } ).each do |data| 
    puts data     
end 

# select levels with creator id = 1
collection.find({ "creator.id": 1}).each do |data| 
    puts data     
end 
    
# select
puts collection.find( { "creator.id": '1' } ).first


# update 
collection.find_one_and_replace( { "creator.id":1, "creator.name": "nicoal"},"$set" => {"creator.id":"2"} )

collection.update_many({ "creator.id":1}, "$set" => {"creator.id":"03"})


#delete

collection.delete_one( { name: 'niveau' } )

collection.delete_many({ "creator.id":03})