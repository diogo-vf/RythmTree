class WSConnection
    attr_reader :id, :session, :key

    public
    def initialize session:, ws_key:
        @id = gen_uuid
        @session = session
        @key = ws_key
        @evt_call_backs = {}

        puts "ws_key #{ws_key}"
        puts "session #{session}"
        

        #listener
        @thread = Thread.new{
            puts "thread handling connection #{@ws_key} with id #{@id}"
            handleConnection
        }
    end

    def register_onmessage #+yield
        evt_id = gen_uuid
        @evt_call_backs[evt_id] = lambda{
            |data|
            yield data
        }
    end
    def unregister_onmessage evt_id
        @evt_call_backs.delete(evt_id)
    end

    private
    def handleConnection
        loop do
            #header
            header_byte = @session.getbyte
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
            payload_header_byte = @session.getbyte
            has_mask = payload_header_byte & 0b10000000
            #length
            payload_initial_length = payload_header_byte & 0b01111111
            length_array = [payload_initial_length]
            length_array = 2.times.map {@session.getbyte} if payload_initial_length == 126
            length_array = 8.times.map {@session.getbyte} if payload_initial_length == 127
            payload_length = 0;
            length_array.each_with_index{
                |value, index|
                power_index = length_array.size - index - 1
                payload_length += value * (256**power_index)
            }

            puts "ws payload header | has_mask: #{has_mask}, payload_length: #{payload_length} bytes"

            #masking key
            masking_key_array = 4.times.map{@session.getbyte}
            puts "ws masking key #{masking_key_array}"

            #body
            masked_body_array = payload_length.times.map {@session.getbyte}
            unmasked_body_array = masked_body_array.each_with_index.map{
                |body_byte, index|
                mask_key_byte = masking_key_array[index % 4]
                body_byte ^ mask_key_byte #xor body byte with mask byte to unmask it
            }
            body = unmasked_body_array.pack('C*').force_encoding("utf-8") #encode array into 8-bit integers str then convert to utf8 str

            puts "ws body : #{body}"
            on_message body
        end
    end
    def on_message data
        @evt_call_backs.keys.each{
            |call_back_key|
            @evt_call_backs[call_back_key].call data
        }
    end
end