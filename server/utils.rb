require 'json'
require 'securerandom'
require 'digest/sha1'
class Utils
    def self.gen_uuid()
        SecureRandom.uuid
    end

    def self.base64_encode data
        Digest::SHA1.base64digest data
    end

    def self.to_base_array(value, base = 256, min_array_length = 0)
        array = []
        current = value
        loop do
            remain = current % base
            current /= base
            array.unshift remain
            break if current == 0
        end
        #min array length
        while array.size < min_array_length
            array.unshift 0
        end
        pp array
        array
    end
    def self.from_array_to_base(array, base = 256)
        value = 0
        array.each_with_index{
            |val, key|
            power = array.size - key - 1
            value += val * (base**power)
        }
        value
    end
    def self.bson_doc_to_hash bson_doc
        hash = {}
        bson_doc.each{ |key, val|
            if val.is_a? BSON::Document
                hash[key.to_sym] = Utils.bson_doc_to_hash val
            elsif val.is_a? Array
                hash[key.to_sym] = Utils.bson_doc_to_array val
            else
                hash[key.to_sym] = val
            end
        }
        
        hash
    end
    def self.bson_doc_to_array bson_array
        array = []
        bson_array.each{ |val|
            if val.is_a? BSON::Document
                array.push Utils.bson_doc_to_hash val
            elsif val.is_a? Array
                array.push Utils.bson_doc_to_array val
            else
                array.push val
            end
        }

        array
    end
end