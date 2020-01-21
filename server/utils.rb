require 'json'
require 'securerandom'
require 'digest/sha1'

def puts_hash data
    puts JSON.generate data;
end

def gen_uuid()
    SecureRandom.uuid
end

def base64_encode data
    Digest::SHA1.base64digest data
end

def to_base_array(value, base = 256, min_array_length = 0)
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
def from_array_to_base(array, base = 256)
    value = 0
    array.each_with_index{
        |val, key|
        multiplier = array.size - key - 1
        value += val * (base**multiplier)
    }
    value
end