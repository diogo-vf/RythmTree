WEB_DIR = __dir__ + "/../../client"
ROOT_ALIASES = [nil, "", "error", "login", "home", "options", "new_game", "lobby_host", "lobby", "new_level", "level_editor", "levels", "replays", "replay_player", "game"]
ROOT_DOCUMENT_PATH = "#{WEB_DIR}/root.html"
MIME_TYPES = {
  "css": "text/css",
  "js": "application/javascript",
  "html": "text/html",
  "text": "text/plain",
  "svg": "image/svg+xml",
  "png": "image/png",
  "jpg": "image/jpeg",
  "jpeg": "image/jpeg",
  "ico": "image/x-icon",
  "gif": "image/gif",
  "webp": "image/webp"
}

class WebServer
  def self.on_request request
    request_url = request[:url]

    filepath = WEB_DIR + request[:url][:path_string]
    if ROOT_ALIASES.include? request_url[:path][0]
      filepath = ROOT_DOCUMENT_PATH
    end

    
    #not found
    return {
        :http_code => :not_found,
        :body => "<h1>Error 404</h1> not found.",
    } unless File.file? filepath

    #read file
    begin
        body_content = ""
        File.open(filepath, 'rb'){|file|
          body_content += file.read
        }
    rescue => exception
        puts "error! " + exception.to_s
        return { 
            :http_code => :server_error, 
            :body => "<h1>Error 500</h1> Internal server error."
        }
    end

    #mime types
    extensionArray = filepath.split "."
    extension = extensionArray[extensionArray.length - 1]
    mime_type = MIME_TYPES[(extension || "html").to_sym]

    #return
    {
      :body => body_content,
      :http_code => :ok,
      :headers => {
          "Content-Length": body_content.length,
          "Content-Type": mime_type,
          #"Cache-Control": "public, max-age=7200",
      }
    }
  end
end
