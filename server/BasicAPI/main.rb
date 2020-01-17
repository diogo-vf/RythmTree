
require_relative "../config/config"
require_relative "mongoDB"
require_relative "basicAPI"


collection_name = "level"
action = "get_many"
data = { "creator.id": 1 }

BasicAPI.new(collection_name,action,data)