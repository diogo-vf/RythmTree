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