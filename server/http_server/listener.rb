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
        server.listen(5678) {
            |error = false, request = false|

            #no request
            next { :httpCode => 500 } unless request

            #forbidden
            next { :httpCode => 403 } if request[:path].include? ".."

            puts "new request: #{request[:path]}"

            url_object = HTTP.decode_url(request[:path])
            request_object = {
              :raw_request => request,
              :url => url_object,
            }

            #web socket
            #pp request

            #web server
            next WebServer.on_request request_object
        }
    end
end
