require "net/http"
require "json"

module Topchan; end
module Topchan::Net

    def self.download(url)
        sleep(1)
        return JSON.parse(Net::HTTP.get(URI(url)))
    end
    
    def self.get_boards()
        begin
            return download("http://a.4cdn.org/boards.json")["boards"].map { |b| b["board"] }
        rescue
            STDERR.puts "Couldn't fetch boards"
            return []
        end
    end
    
    def self.get_threads(board_id)
        begin
            return download("http://a.4cdn.org/#{board_id}/threads.json").flat_map { |p| p["threads"] }
        rescue
            STDERR.puts "Couldn't fetch threads in /#{board_id}"
            return []
        end
    end
    
    def self.get_posts(board_id, thread_id)
        begin
            return download("http://a.4cdn.org/#{board_id}/thread/#{thread_id}.json")["posts"]
        rescue
            STDERR.puts "Couldn't fetch posts in /#{board_id}/#{thread_id}"
            return []
        end
    end
end
