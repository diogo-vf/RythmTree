WEB_DIR = __dir__ + "/../../client"
ROOT_ALIASES = [nil, "", "error", "login", "home", "new_game", "lobby_host", "lobby", "new_level", "level_editor", "levels", "replays", "replay_player", "game"]
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
FILE_READ_BUFFER_SIZE = 255

class WebServer
  def self.on_request(request)
    request_url = request[:url]

    filepath = WEB_DIR + request[:url][:path_string]
    if ROOT_ALIASES.include? request_url[:path][0]
      filepath = ROOT_DOCUMENT_PATH
    end

    
    #not found
    return {
        :http_code => 404,
        :body => "<h1>Error 404</h1> not found.",
    } unless File.file? filepath

    #read file
    begin
        # file = open filepath
        # puts file.read
        # body_content = file.read
        # file.close
        body_content = ""
        # File.foreach(filepath){|line|
        #     puts line
        #     body_content += line
        # }
        puts "file data: "
        File.open(filepath, 'rb'){|file|
            loop do
                break unless buf = file.gets(nil, FILE_READ_BUFFER_SIZE)
                body_content += buf
            end
        }
    rescue => exception
        puts "error! " + exception.to_s
        return { 
            :http_code => 500, 
            :body => "<h1>Error 500</h1> Internal server error."
        }
    end

    #mime types
    extensionArray = filepath.split "."
    extension = extensionArray[extensionArray.length - 1]
    mime_type = MIME_TYPES[(extension || "text").to_sym]

        #puts body_content
    #return
    {
      :body => body_content,
      :http_code => 200,
      :mime_type => mime_type
    }
  end
end
