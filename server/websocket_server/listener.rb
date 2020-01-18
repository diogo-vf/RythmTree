#https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/


#require_relative '../utils'

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
        
        connection_id = gen_uuid
        connection_handler = Thread.new{
            puts "thread handling connection #{ws_key}"
            loop do
                puts "hello! #{ws_key}"
                sleep 1
            end
        }
        #store connection
        @connections[ws_key] = {
            :ws_key => ws_key,
            :session => session,
            :handler_thread => connection_handler
        }

        puts "websocket handshake complete for #{ws_key}"
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

    private
    def handleConnection id

    end
end