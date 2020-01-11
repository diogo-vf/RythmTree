require_relative "http_server/listener"
require_relative "websocket_server/listener"

while
    begin
        HTTPServer.start
    rescue => exception
        puts "the script crashed #{exception.to_s}"
        sleep 1
        puts "restarting..."
    end
end
