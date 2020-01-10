require_relative "http_server/listener"
require_relative "websocket_server/listener"

while
    begin
        HTTPServer.start
        sleep(1.second)
    rescue => exception
        puts "the script crashed #{exception.to_s}"
        sleep(1.second)
        puts "restarting..."
    end
end
