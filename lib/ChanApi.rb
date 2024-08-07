require "net/http"

class ChanApi
  
  def get_boards
    
  end

  private 

  def http_get(url)
    return Net::HTTP.get(URI.parse(url))
  end

end
