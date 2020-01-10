# web server
# Author: Nicolas Maitre
# Date: 07.01.2020

require_relative "http"
require_relative "web"

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
            next WebServer.on_request request_object
        }
    end
end
