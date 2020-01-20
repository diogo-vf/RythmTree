#https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/
#readable spec: https://lucumr.pocoo.org/2012/9/24/websockets-101/

require 'pp'
require_relative 'connection'

WS_SECURITY_KEY = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
class WebSocketServer
    public
    def initialize
        @connections = {}
    end
    def on_http_connection req, session
        headers = req[:headers]
        return {
            :body => "<h1>Error 418</h1> What the hell are you doing?",
            :http_code => :teapot
        }unless headers["Upgrade"] == "websocket"

        unless ws_key = headers["Sec-WebSocket-Key"]
            puts "websocket error, no key provided"
            return {
                :http_code => :user_error,
                :body => "<h1>Error 400</h1> user error xD"
            }
        end

        puts "initiating connection with key #{ws_key}"
        #handshake
        res_ws_key = base64_encode ws_key + WS_SECURITY_KEY
        puts "respond with key #{res_ws_key}"
        
        puts "websocket handshake complete for #{ws_key}"
        #store connection
        connection = WSConnection.new(session: session, ws_key: ws_key)
        @connections[connection.id] = connection

        connection.register_onmessage{
            |data|
            puts "hello! i got the data: #{data}"
        }

        {
            :http_code => :switching_protocols,
            :headers => {
                "Upgrade": "websocket",
                "Connection": "Upgrade",
                "Sec-WebSocket-Accept": res_ws_key
            },
            :prevent_session_close => true
        }        
    end
end