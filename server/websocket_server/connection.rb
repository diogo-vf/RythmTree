#https://tools.ietf.org/html/rfc6455

require 'json'
require_relative '../actions'
class WSConnection
    attr_reader :id, :session, :key

    OPCODES = {
        "0": "Continuation",
        "1": "Text",
        "2": "Binary",
        "8": "Connection Close",
        "9": "Ping",
        "10": "Pong"
    }
    SUPPORTED_OPCODES = [1, 8]

    public
    def initialize session:, ws_key:
        @id = Utils.gen_uuid
        @session = session
        @key = ws_key
        @evt_call_backs = {}
        @status = "open"

        puts "ws_key #{ws_key}"
        puts "session #{session}"
        

        #listener
        @thread = Thread.new{
            puts "thread handling connection id #{@id} (key: #{@ws_key})"
            handleConnection
        }
    end

    def send_message body
        puts "send_message"
        puts "body size:#{body.bytesize}"
        #header
        fin = 1
        opcode = 1
        header_byte = (fin * 128) + (opcode)

        #payload header
        #mask
        has_mask = 0 #develop that if you want to encrypt data
        has_mask_val = has_mask * 128
        #length
        body_lenght = body.bytesize
        payload_header_array = [has_mask_val + body_lenght] # <126
        if body_lenght >= (2**16 - 1)#>16bit
            payload_header_array = [has_mask_val + 127] + Utils.to_base_array(body_lenght, 256, 8)
        elsif body_lenght >= 125 #>~7bit
            payload_header_array = [has_mask_val + 126] + Utils.to_base_array(body_lenght, 256, 2)
        end

        #response
        response_array = [header_byte] + payload_header_array + [body]
        response_pack_param_str = "CC#{payload_header_array.size}A#{body_lenght}"
        response = response_array.pack response_pack_param_str#writes 2 8-bit ints followed by body string (should be changed when supporting longer payloads)
        begin
            @session.write response
        rescue => exception
            puts "error during send_message print"
        end
    end

    def close propagate = true
        if propagate && false
            fin = 1
            opcode = 8
            header_byte = (opcode * 128) + (opcode)
            @session.write [header_byte].pack "C"
        end
        puts("closing connection");
        @status = "closed"
        @session.close
        @thread.exit
    end

    private
    def handleConnection
        loop do
            #header
            header_byte = @session.getbyte
            fin = header_byte & 0b10000000
            rsv = header_byte & 0b01110000
            opcode = header_byte & 0b00001111
                # puts "ws header | fin: #{fin}, rsv: #{rsv}, opcode: #{opcode}"
            
            raise "ws currently only supports single frame payloads" unless fin
            raise "unsupported opcode #{opcode} -> \"#{OPCODES[opcode.to_s.to_sym]}\"" unless SUPPORTED_OPCODES.include? opcode

            return close(false) if opcode == 8 #connection close
            
            #payload header
            payload_header_byte = @session.getbyte
            has_mask = payload_header_byte & 0b10000000
            #length
            payload_initial_length = payload_header_byte & 0b01111111
            length_array = [payload_initial_length]
            length_array = 2.times.map {@session.getbyte} if payload_initial_length == 126
            length_array = 8.times.map {@session.getbyte} if payload_initial_length == 127
            payload_length = Utils.from_array_to_base(length_array, 256);

            #masking key
            masking_key_array = 4.times.map{@session.getbyte}

            #body
            masked_body_array = payload_length.times.map {@session.getbyte}
            unmasked_body_array = masked_body_array.each_with_index.map{
                |body_byte, index|
                mask_key_byte = masking_key_array[index % 4]
                body_byte ^ mask_key_byte #xor body byte with mask byte to unmask it
            }
            body = unmasked_body_array.pack('C*').force_encoding("utf-8") #encode array into 8-bit integers str then convert to utf8 str

            on_message body
        end
    end
    def on_message data
        actionThread = Thread.new{
            msg_object = JSON.parse(data)
            # TODO show/disable new data
            pp "new msg", msg_object  
            result = WSActions.on_ws_action(self, msg_object["action"], msg_object["data"])

            #return
            if(result && msg_object["requestId"])
                request_id = msg_object["requestId"]
                puts "action #{msg_object["action"]} needs return for connectionId #{request_id}"
                return_data = {
                    requestId: request_id,
                    action: "returnData",
                    data: result
                }
                
                send_message(return_data.to_json)
            end
        }
    end
end