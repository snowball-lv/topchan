require "net/http"

class ChanApi
  
  def get_boards
    url = "https://a.4cdn.org/boards.json"
    return JSON.parse(http_get(url))["boards"]
  end

  def get_threads(board_code)
    url = "https://a.4cdn.org/#{board_code}/threads.json"
    pages = JSON.parse(http_get(url))
    return pages.flat_map { |page| page["threads"] }
  end

  def get_posts(board_code, thread_no)
    url = "https://a.4cdn.org/#{board_code}/thread/#{thread_no}.json"
    return JSON.parse(http_get(url))["posts"]
  end

  private 

  def http_get(url)
    sleep 1
    return Net::HTTP.get(URI.parse(url))
  end

end
