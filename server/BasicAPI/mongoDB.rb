require 'mongo'

class MongoDB
    def initialize
        db_ip = "192.168.178.134"
        db_port = 27017
        db_name = "RythmTree"
        @client = Mongo::Client.new([ "#{db_ip}:#{db_port}" ], :database => db_name)
    end
end