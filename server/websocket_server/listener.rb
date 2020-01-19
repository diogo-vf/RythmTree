#https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/

require 'pp'

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
            puts "thread handling connection #{ws_key} with id #{connection_id}"
            handleConnection(connection_id)
        }
        #store connection
        @connections[connection_id] = {
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
    def handleConnection connection_id
        # frame schema
        # 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
        # +-+-+-+-+-------+-+-------------+-------------------------------+
        # |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
        # |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
        # |N|V|V|V|       |S|             |   (if payload len==126/127)   |
        # | |1|2|3|       |K|             |                               |
        # +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
        # |     Extended payload length continued, if payload len == 127  |
        # + - - - - - - - - - - - - - - - +-------------------------------+
        # |                               |Masking-key, if MASK set to 1  |
        # +-------------------------------+-------------------------------+
        # | Masking-key (continued)       |          Payload Data         |
        # +-------------------------------- - - - - - - - - - - - - - - - +
        # :                     Payload Data continued ...                :
        # + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
        # |                     Payload Data continued ...                |
        # +---------------------------------------------------------------+
        connection = @connections[connection_id]
        session = connection[:session]
        header_byte = session.getbyte
        puts header_byte
        puts "hmm"
        # loop do
        #     puts "hello! #{connection_id} #{Time.now}"
        #     sleep 1
        # end
    end
end