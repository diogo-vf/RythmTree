require 'mongo'

class MongoDB
    def initialize 
        # Disable notifications on console       
        Mongo::Logger.logger.level = ::Logger::FATAL
        @client=Mongo::Client.new([ "#{DB_IP}:#{DB_PORT}" ], :database => DB_NAME)
    end

    public 
    def client
        @client
    end

    # Define the table to use
    def collection=(collection_name)
        @collection = @client[collection_name]
    end

    def collection
        @collection
    end
end