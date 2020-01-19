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
        loop do
            #header
            header_byte = session.getbyte
            fin = header_byte & 0b10000000
            rsv = header_byte & 0b01110000
            opcode = header_byte & 0b00001111

            puts "ws header | fin: #{fin}, rsv: #{rsv}, opcode: #{opcode}"
            unless fin
                puts "ws currently only supports single frame payloads"
                return
            end
            unless opcode == 1
                puts "ws currently only supports text requests"
                return
            end
            
            #payload header
            payload_header_byte = session.getbyte
            has_mask = payload_header_byte & 0b10000000
            payload_length = payload_header_byte & 0b01111111
            if payload_length >= 126
                lengths_array = [payload_length]
                while (current_length = session.getbyte)
                    break;
                    puts "current_length: #{current_length}"
                    lengths_array.push current_length
                    #break if current_length < 254
                end
                puts "lengths array: #{lengths_array}"
                puts "ws currently only supports request of up to 126 bits in length"
                return
            end

            puts "ws payload header | has_mask: #{has_mask}, payload_length: #{payload_length} bytes"

            #masking key
            masking_key_array = 4.times.map{session.getbyte}
            puts "ws masking key #{masking_key_array}"

            #body
            masked_body_array = payload_length.times.map {session.getbyte}
            unmasked_body_array = masked_body_array.each_with_index.map{
                |body_byte, index|
                mask_key_byte = masking_key_array[index % 4]
                body_byte ^ mask_key_byte #xor body byte with mask byte to unmask it
            }
            body = unmasked_body_array.pack('C*').force_encoding("utf-8") #encode array into 8-bit integers str then convert to utf8 str

            puts "ws body : #{body}"

            # loop do
            #     puts "hello! #{connection_id} #{Time.now}"
            #     sleep 1
            # end
        end
    end

    def self.decode_request bytes_array

    end
end