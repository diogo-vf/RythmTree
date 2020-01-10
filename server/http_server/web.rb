WEB_DIR = __dir__ + "/../../client"
ROOT_ALIASES = [nil, "", "error", "login", "home", "new_game", "lobby_host", "lobby", "new_level", "level_editor", "levels", "replays", "replay_player", "game"]
ROOT_DOCUMENT_PATH = "#{WEB_DIR}/root.html"

class WebServer
  def self.on_request(request)
    request_url = request[:url]

    filepath = WEB_DIR + request[:url][:path_string]
    if ROOT_ALIASES.include? request_url[:path][0]
      filepath = ROOT_DOCUMENT_PATH
    end

    #not found
    return {
        :httpCode => 404,
        :body => "<h1>Error 404</h1> not found.",
    } unless File.file? filepath

    #read file
    begin
      file = open filepath
      body_content = file.read
      file.close
    rescue => exception
        puts "error! " + exception.to_s
        return { :httpCode => 500 }
    end

    #return
    return {:body => body_content}
  end
end
