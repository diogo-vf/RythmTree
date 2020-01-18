
require_relative "../config/config"
require_relative "mongoDB"
#require_relative "basicAPI/basicAPI"
require_relative "inDeveloppement/api_diogo"

hash={
    "action": "get",
    "collection_name": "level",
    "data": {
         "_id": '5e2198f66e955215e787420f',
         name: "niveau" 
    }
}

connection=BasicAPI.connection
BasicAPI.actions(connection,hash)
