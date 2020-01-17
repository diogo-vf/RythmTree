# basic http server
# Author: Nicolas Maitre
# Date: 07.01.2020

require "socket"
require "uri"
require_relative "utils"

class HTTP
  def listen(port) # +yield
    tcp_server = TCPServer.new port
    puts "Listening on port #{port}"
    while session = tcp_server.accept
      requestLines = [];
      while line = session.gets
        break if line.strip=="" #tmp
        requestLines.push(line);
      end
      parsedRequest = HTTP.parse_request(requestLines)

      unless parsedRequest
        yield("invalid request")
        next
      end

      returnData = (yield(false, parsedRequest) || {})

      begin
        session.print "HTTP/1.1 #{(returnData[:http_code] || 200).to_s}\r\n" #http code
        session.print "Content-Type: #{(returnData[:mime_type] || "text/html")}\r\n" #mime type
        session.print "\r\n"
        session.print "#{(returnData[:body] || "").to_s}" #body
      rescue
        puts "request return print failed"
      end

      session.close
    end
  end

  #STATIC METHODS
  def self.parse_request(requestLines)
    #pp requestLines
    #return nil unless request.class == String
    request = requestLines[0] #tmp
    requestArray = request.split(" ")

    return {
             :method => requestArray[0],
             :path => requestArray[1],
             :protocol => requestArray[2],
             :req => requestLines
           }
  end

  def self.decode_url(url)
    url_object = URI.parse(url)

    path = self.decode_path url_object.path

    query = self.decode_query url_object.query

    {
      :string => url,
      :path => path,
      :path_string => url_object.path,
      :query => query,
      :url_object => url_object,
    }
  end

  def self.decode_query(query_string)
    return {} unless query_string
    query_array = URI.decode_www_form query_string
    query = {}
    query_array.each { |query_entry|
      query[query_entry[0]] = query_entry[1]
    }

    query
  end
  def self.decode_path(path_string)
    return [] unless path_string
    path_encoded = path_string.split "/"
    if path_encoded[0] == "" #empty path
      path_encoded = path_encoded.slice(1, path_encoded.length - 1)
    end
    path = []
    path_encoded.each { |path_component|
      path.push URI.decode_www_form_component(path_component)
    }

    path
  end
end
