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
        server.listen(HTTP_PORT) {
            |error = false, request = false, session = false|

            #error
            next {:httpCode => 500, :body => "<h1>Error 500</h1> #{error.to_s}"} if error

            #no request
            next { :httpCode => 500 } unless request

            #forbidden
            next { :httpCode => 403 } if request[:url][:path_string].include? ".."

            puts "new request: #{request[:url][:path_string]}"

            #endpoint switch
            case request[:url][:path][0]
                when 'websocket'
                    next WebSocketServer.inst.on_http_connection request, session
                else
                    #web server
                    next WebServer.on_request request
            end
        }
    end
end
