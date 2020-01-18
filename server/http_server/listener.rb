# web server
# Author: Nicolas Maitre
# Date: 07.01.2020

require "pp"
require_relative "http"
require_relative "web"
require_relative "../websocket_server/listener"

class HTTPServer
    def self.start
        server = HTTP.new
        wsServer = WebSocketServer.new
        server.listen(5678) {
            |request = false, session = false|

            #no request
            next { :httpCode => 500 } unless request

            #forbidden
            next { :httpCode => 403 } if request[:url][:path_string].include? ".."

            puts "new request: #{request[:url][:path_string]}"

            #endpoint switch
            case request[:url][:path][0]
                when 'websocket'
                    next wsServer.on_http_connection request, session
                else
                    #web server
                    next WebServer.on_request request
            end
        }
    end
end
