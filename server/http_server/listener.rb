require_relative 'http'

server = HTTP.new
server.listen(5678){
    |error=false, request=false|
    {
        :body => bodyContent
    }
}