require 'mongo'

class MongoDB
    def initialize
        
        Mongo::Logger.logger.level = ::Logger::FATAL
        @client=Mongo::Client.new([ "#{DB_IP}:#{DB_PORT}" ], :database => DB_NAME)
    end

    public 
    def client
        @client
    end

    def collection=(collection_name)
        @collection = @client[collection_name]
    end

    def collection
        @collection
    end
end