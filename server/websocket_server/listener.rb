#https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/
#readable spec: https://lucumr.pocoo.org/2012/9/24/websockets-101/
#spec https://tools.ietf.org/html/rfc6455

require 'pp'
require_relative 'connection'
require_relative '../actions'

WS_SECURITY_KEY = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
class WebSocketServer
    @@instance = nil
    public
    def initialize pineapple = "nope"
        raise "this class uses the singleton principle. use \"WebsocketServer.inst\" to get the instance." until pineapple == "pamplemousse"
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
        res_ws_key = Utils.base64_encode ws_key + WS_SECURITY_KEY
        puts "respond with key #{res_ws_key}"
        
        puts "websocket handshake complete for #{ws_key}"
        #store connection
        connection = WSConnection.new(session: session, ws_key: ws_key)
        @connections[connection.id] = connection

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
    def on_connection_close connection
        @connections.delete(connection.id.to_sym)
    end

    def self.inst
        return @@instance if @@instance
        @@instance = self.new "pamplemousse"
    end
end