#https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/

require "digest"

WS_SECURITY_KEY = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
class WebSocketServer
    public
    def initialize

    end
    def on_http_connection(req)
        headers = req[:headers]
        return {
            :body => "<h1>Error 418</h1> What the hell are you doing?",
            :http_code => :teapot
        }unless headers["Upgrade"] == "websocket"

        unless ws_key = headers["Sec-WebSocket-Key"]
            puts "websocket error, no key provided"
        end

        puts "initiating connection with key #{ws_key}"

        #handshake
        res_ws_key = Digest::SHA1.base64digest(ws_key + WS_SECURITY_KEY)
        puts "respond with key #{res_ws_key}"

        {
            :httpCode => :switching_protocols,
            :headers => {
                "Upgrade": "websocket",
                "Connection": "Upgrade",
                "Sec-WebSocket-Accept": res_ws_key
            },
            :prevent_session_close => true
        }        
    end
end