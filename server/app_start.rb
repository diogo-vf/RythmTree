require "pp"
require_relative "config/config"
require_relative "http_server/listener"
require_relative "websocket_server/listener"
require_relative "utils"

HTTPServer.start