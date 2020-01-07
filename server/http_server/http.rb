require 'socket'
class HTTP
    def initialize

    end
    private def parseRequest(request)
        return nil unless request.class == String

        requestArray = request.split(" ");

        return {
            :method=> requestArray[0],
            :path=> requestArray[1],
            :protocol=> requestArray[2]
        }
    end
    def listen(port) # +yield
        tcp_server = TCPServer.new port

        while session = tcp_server.accept
            request = session.gets
            parsedRequest = parseRequest(request)
        
            unless parsedRequest
                yield("invalid request")
                next
            end
            
            returnData = (yield(false, parsedRequest)||{});

            session.print "HTTP/1.1 #{(returnData[:httpCode]||200).to_s}\r\n" #http code
            session.print "Content-Type: #{(returnData[:mimeType]||"text/html")}\r\n" #mime type
            session.print "\r\n"
            session.print "#{(returnData[:body]||"").to_s}"
          
            session.close
        end
    end
end